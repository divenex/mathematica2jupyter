(* ::Package:: *)
(* :Name: Mathematica2Jupyter *)
(* :Author: https://github.com/divenex *)
(* :Date: 2025-05-24 *)
(* :Summary: Converts Mathematica notebooks (.nb) to Jupyter Notebook format (.ipynb) *)
(* :Context: Mathematica2Jupyter` *)
(* :Package Version: 1.0 *)
(* :Mathematica Version: 12.0+ *)
(* :Copyright: (c) 2025 divenex (https://github.com/divenex) *)

BeginPackage["Mathematica2Jupyter`"];

Mathematica2Jupyter::usage = "Mathematica2Jupyter[inputFile] 
    converts a Mathematica notebook (.nb) specified by inputFile to VSCode Notebook (.vsnb) format.
    The output file is saved to the same location as the input file but with .vsnb extension.
    Returns the path to the created .vsnb file upon success, or $Failed if conversion fails.";

Begin["`Private`"];

Mathematica2Jupyter::unparsed = "Unrecognized form encountered during conversion: `1`";

prefix = <|"Title"               -> "# ",
           "Subtitle"            -> "### ",
           "Chapter"             -> "# ", 
           "Section"             -> "---\n## ",
           "Subsection"          -> "### ",
           "Subsubsection"       -> "#### ",
           "Item"                -> "-   ",
           "ItemNumbered"        -> "1.  ",
           "ItemParagraph"       -> "    ",    
           "Subitem"             -> "    -   ", 
           "SubitemNumbered"     -> "    1.  ",
           "SubitemParagraph"    -> "        ",    
           "Subsubitem"          -> "        -   ", 
           "SubsubitemNumbered"  -> "        1.  ",
           "SubsubitemParagraph" -> "            "|>

processItem[TextData[elems_]] := StringJoin[processItem /@ Flatten[{elems}]];  (* Recursive *)

processItem[StyleBox[txt_String, "Input", ___]] := " `" <> StringTrim[txt] <> "` "

processItem[StyleBox[txt_String, FontSlant->"Italic", ___]] := " *" <> StringTrim[txt] <> "* "
    
processItem[StyleBox[txt_String, FontWeight->"Bold", ___]] := " **" <> StringTrim[txt] <> "** "

processItem[fmt_StyleBox] := ExportString[fmt, "HTMLFragment"]

processItem[ButtonBox[txt_String, ___, ButtonData->{___, URL[url_String], ___}, ___]] := 
    " [" <> txt <> "](" <> url <> ") "

processItem[expr_?(!FreeQ[#, _RasterBox]&)] := 
    ExportString[Image[First[
        Cases[expr, RasterBox[CompressedData[data__String], ___] :> Uncompress[data], Infinity]
    ], ColorSpace -> "RGB"], "HTMLFragment"]

cond = (StringContainsQ[#, "$"] && StringFreeQ[#, {"{", "}"}])&

(* Also includes a fix for ExportString bugs producing TeX like \(\text{\textit{2$\sigma$r}}\) or \(x{}^2\) *)
processItem[Cell[box_BoxData, ___] | box_BoxData] := 
    StringReplace[ExportString[box, "TeXFragment"], 
        { "\\text{\\textit{" ~~ str__ ~~ "}}" /; cond[str] :> StringDelete[str, "$"],
         ("\\text{" | "\\textit{") ~~ str__ ~~ "}" /; cond[str] :> StringDelete[str, "$"],
          "\\(" -> " $", "\\)" -> "$ ", "{}" | "\r\n" -> ""}]

processItem[str_String] := str

processItem[unknown_] := (Message[Mathematica2Jupyter::unparsed, unknown]; "---UNPARSED---")

processText[cnt_, type_] := Lookup[prefix, type, ""] <> StringReplace[processItem[cnt], "\n" -> "\n\n"]

processInput[_?(!FreeQ[#, _RasterBox]&)] := "---IMAGE---"

processInput[cnt_] := StringReplace[StringTake[
    ToString[ToExpression[cnt, StandardForm, HoldComplete], InputForm], 
        {14, -2}], ", Null, " | (", Null" ~~ EndOfString) -> "\n"]

processCell[style_, Cell[cnt_, ___]] :=
    AssociationThread[{"cell_type", "metadata", "source"} -> Switch[style,
        "DisplayFormula" | "DisplayFormulaNumbered", 
                          {"markdown", <||>, StringReplace[processItem[cnt], "$" -> "$$"]},
        "Input" | "Code", {"code",     <||>, processInput[cnt]},
        _,                {"markdown", <||>, processText[cnt, style]}]]

mergeMarkdownCells[cells_] := SequenceReplace[cells,{c__?(#["cell_type"] === "markdown"&)} :> 
    <|c, "source" -> StringRiffle[Lookup[{c}, "source"], "\n\n"]|>]
                                                                          
Mathematica2Jupyter[inputFile_?FileExistsQ] := Export[FileBaseName[inputFile] <> ".ipynb", 
    {"cells" -> mergeMarkdownCells@NotebookImport[inputFile, 
          Except["Output" | "Message"] -> (processCell[#1,#2]&)],   
     "metadata" -> {"language_info" -> {"name" -> "wolfram", "pygments_lexer" -> "wolfram", 
          "codemirror_mode" -> "mathematica","mimetype" -> "application/mathematica"}}}, "JSON"]

End[]

EndPackage[]
