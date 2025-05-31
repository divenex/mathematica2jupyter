(* ::Package:: *)
(* :Name: Mathematica2Jupyter *)
(* :Author: https://github.com/divenex *)
(* :Date: 2025-05-24 *)
(* :Summary: Converts Mathematica notebooks (.nb) to Jupyter Notebook format (.ipynb) *)
(* :Context: Mathematica2Jupyter` *)
(* :Package Version: 1.1 *)
(* :Mathematica Version: 12.0+ *)
(* :Copyright: (c) 2025 divenex (https://github.com/divenex) *)

BeginPackage["Mathematica2Jupyter`"];

Mathematica2Jupyter::usage = "Mathematica2Jupyter[inputFile, format] 
    converts a Mathematica notebook (.nb) to Jupyter (.ipynb) or VSCode (.wlnb/.wsnb) format.
    format (optional): \"ipynb\" (default) or \"wlnb\"/\"vsnb\".
    Returns the path to the created file upon success, or $Failed if conversion fails.";

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

typeHead[fmt_] := If[fmt === "ipynb", "cell_type", "languageId"]
contentHead[fmt_] := If[fmt === "ipynb", "source", "value"]
codeType[fmt_] := If[fmt === "ipynb", "code", "wolfram"]

processCell[style_, Cell[cnt_, ___], fmt_] :=
    AssociationThread[{typeHead[fmt], "metadata", contentHead[fmt], "kind"} -> Switch[style,
        "DisplayFormula" | "DisplayFormulaNumbered", 
            {"markdown", <||>, StringReplace[processItem[cnt], "$" -> "$$"], 1},        
        "Input" | "Code", {codeType[fmt], <||>, processInput[cnt], 2},
        _, {"markdown", <||>, processText[cnt, style], 1}
    ]]

mergeMarkdownCells[cells_, fmt_] := 
    SequenceReplace[cells, {c__?(#[typeHead[fmt]] === "markdown"&)} :> 
        <|c, contentHead[fmt] -> StringRiffle[Lookup[{c}, contentHead[fmt]], "\n\n"]|>]
                                                                          
Mathematica2Jupyter[inputFile_?FileExistsQ, fmt_String:"ipynb"] := 
    (cells = mergeMarkdownCells[NotebookImport[inputFile, 
        Except["Output" | "Message"] -> (processCell[#1, #2, fmt]&)], fmt];
     Export[FileBaseName[inputFile] <> "." <> fmt, 
        If[fmt === "ipynb",
            <|"cells" -> cells, "metadata" -> <|"language_info" -> <|"name" -> "wolfram", 
                "pygments_lexer" -> "wolfram", "codemirror_mode" -> "mathematica", 
                "mimetype" -> "application/mathematica"|>|>|>,
            <|"cells" -> cells|>
        ], "JSON"])

End[]

EndPackage[]
