# Mathematica2Jupyter: Mathematica Notebooks to Jupyter or VS Code

Converts Mathematica notebooks (.nb) to Jupyter (.ipynb) or VS Code (.wlnb/.vsnb) Notebook formats.

## Author

[divenex](https://github.com/divenex)

## Date

2025-05-24

## Summary

This `Mathematica2Jupyter` Wolfram Language package provides a function to convert Mathematica notebooks (`.nb` files) into either Jupyter Notebook files (`.ipynb`) or VS Code Notebook files (`.wlnb`/`.vsnb`). This allows for easier viewing and interaction with Mathematica notebook content within either the Jupyter environment or VS Code, leveraging their native notebook interfaces. 

The resulting `.ipynb` files are meant to be used with the official [Wolfram Language kernel for Jupyter notebooks](https://github.com/WolframResearch/WolframLanguageForJupyter). 

For VS Code, there are two notebook extensions available:
- `.wlnb` files work with the [Wolfram Language Notebook extension](https://marketplace.visualstudio.com/items?itemName=njpipeorgan.wolfram-language-notebook)
- `.vsnb` files work with the [official Wolfram Language extension](https://marketplace.visualstudio.com/items?itemName=WolframResearch.wolfram)

Note: The `.wlnb` and `.vsnb` formats are functionally identical and differ only in their file extension. 

The conversion handles various cell types including:
*   Input cells (converted to Wolfram Language code cells)
*   Text cells (Title, Section, Subsection, Item)
*   Styled text (bold, italic, font color) - best effort conversion to Markdown
*   Hyperlinks
*   TeX-like formulas (DisplayFormula)

## Package Version

1.0

## Mathematica Version

Requires Mathematica 12.0 or newer.

## Copyright

(c) 2025 divenex (https://github.com/divenex)

## Function

### `Mathematica2Jupyter[inputFile, format]`

**Usage:**

`Mathematica2Jupyter[inputFile, format]`

**Details:**

*   `inputFile`: A string representing the full path to the Mathematica notebook (`.nb`) file you want to convert.
*   `format` (optional): A string specifying the output format:
    *   `"ipynb"` (default) - Creates Jupyter Notebook format
    *   `"wlnb"` - Creates VS Code Notebook format for the Wolfram Language Notebook extension
    *   `"vsnb"` - Creates VS Code Notebook format for the official Wolfram Language extension
*   The function converts the specified Mathematica notebook to the chosen format.
*   The output file is saved in the same directory as the input file, with the same base name but with the appropriate extension (`.ipynb`, `.wlnb`, or `.vsnb`).
*   Returns the absolute path to the created file upon successful conversion.
*   Returns `$Failed` if the conversion fails (e.g., if the input file does not exist).

## How to Use

1.  **Load the Package:**
    Make sure the `Mathematica2Jupyter.wl` file is in a location where Mathematica can find it (e.g., your working directory, a directory in `$Path`, or install it as a package).
    Then, load the package into your Mathematica session:
    ```wolfram
    Get["path/to/Mathematica2Jupyter.wl"] 
    (* Or if installed/in $Path *)
    Needs["Mathematica2Jupyter`"]
    ```

2.  **Convert a Notebook:**
    Call the `Mathematica2Jupyter` function with the path to your `.nb` file:
    
    **For Jupyter Notebook (.ipynb):**
    ```wolfram
    Mathematica2Jupyter["C:\Users\YourName\Documents\MyNotebook.nb"]
    (* or explicitly specify format *)
    Mathematica2Jupyter["C:\Users\YourName\Documents\MyNotebook.nb", "ipynb"]
    ```
      **For VS Code Notebook (.wlnb):**
    ```wolfram
    Mathematica2Jupyter["C:\Users\YourName\Documents\MyNotebook.nb", "wlnb"]
    ```
    
    **For VS Code Notebook (.vsnb):**
    ```wolfram
    Mathematica2Jupyter["C:\Users\YourName\Documents\MyNotebook.nb", "vsnb"]
    ```
    
    Or using a relative path if appropriate:
    ```wolfram
    SetDirectory[NotebookDirectory[]]; (* Or any other relevant directory *)
    Mathematica2Jupyter["MyNotebook.nb", "wlnb"]
    ```

3.  **Open in Target Application:**
    The converted file will be created in the same directory as the original `.nb` file. You can then:
    - Open `.ipynb` files with Jupyter Notebook or JupyterLab
    - Open `.wlnb` files with VS Code using the Wolfram Language Notebook extension
    - Open `.vsnb` files with VS Code using the official Wolfram Language extension

## Example

```wolfram
(* Assuming Mathematica2Jupyter.wl is in the current working directory or $Path *)
Needs["Mathematica2Jupyter`"]

(* Specify the path to your Mathematica notebook *)
notebookPath = "C:\Path\To\Your\Mathematica\Notebooks\Example.nb";

(* Convert to Jupyter format (default) *)
Mathematica2Jupyter[notebookPath]

(* Convert to VS Code format for Wolfram Language Notebook extension *)
Mathematica2Jupyter[notebookPath, "wlnb"]

(* Convert to VS Code format for official Wolfram Language extension *)
Mathematica2Jupyter[notebookPath, "vsnb"]

(* Convert to Jupyter format explicitly *)
Mathematica2Jupyter[notebookPath, "ipynb"]
```

## Notes

*   The conversion process attempts to map Mathematica cell styles (Title, Section, Input, etc.) to appropriate Markdown or code cells in the target notebook format.
*   Input cells from Mathematica are converted to Wolfram Language code cells that can be executed in either Jupyter (with Wolfram kernel) or VS Code (with appropriate Wolfram extension).
*   The format parameter accepts "ipynb" for Jupyter, "wlnb" for the Wolfram Language Notebook extension, and "vsnb" for the official Wolfram Language extension.
*   The .wlnb and .vsnb formats are functionally identical and differ only in their file extension to match their respective VS Code extensions.
*   Some complex or highly customized Mathematica notebook features might not be perfectly translated.
*   The package includes a fix for a known `ExportString` bug that can affect the rendering of TeX fragments containing `$`.

## Screenshot

![Image](https://i.sstatic.net/te5xlpyf.jpg)

## Inspiration

This package was inspired by the approach described in [Converting Wolfram Notebooks to Markdown](https://practicalwolf.com/2020/04/02/converting-wolfram-notebooks-to-markdown.html).
