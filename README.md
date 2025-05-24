# Mathematica2Jupyter: Mathematica Notebooks to Jupyter

Converts Mathematica notebooks (.nb) to Jupyter Notebook format (.ipynb).

## Author

[divenex](https://github.com/divenex)

## Date

2025-05-24

## Summary

This `Mathematica2Jupyter` Wolfram Language package provides a function to convert Mathematica notebooks (`.nb` files) into Jupyter Notebook files (`.ipynb`). This allows for easier viewing and interaction with Mathematica notebook content within the Jupyter environment, leveraging its native notebook interface.

The conversion handles various cell types including:
*   Input cells (Python code, assuming conversion from Wolfram Language)
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

### `Mathematica2Jupyter[inputFile]`

**Usage:**

`Mathematica2Jupyter[inputFile]`

**Details:**

*   `inputFile`: A string representing the full path to the Mathematica notebook (`.nb`) file you want to convert.
*   The function converts the specified Mathematica notebook to the Jupyter Notebook (`.ipynb`) format.
*   The output `.ipynb` file is saved in the same directory as the input file, with the same base name but a `.ipynb` extension.
*   Returns the absolute path to the created `.ipynb` file upon successful conversion.
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
    ```wolfram
    Mathematica2Jupyter["C:\Users\YourName\Documents\MyNotebook.nb"]
    ```
    Or using a relative path if appropriate:
    ```wolfram
    SetDirectory[NotebookDirectory[]]; (* Or any other relevant directory *)
    Mathematica2Jupyter["MyNotebook.nb"]
    ```

3.  **Open in Jupyter:**
    The converted `.ipynb` file will be created in the same directory as the original `.nb` file. You can then open this `.ipynb` file with Jupyter Notebook or JupyterLab.

## Example

```wolfram
(* Assuming Mathematica2Jupyter.wl is in the current working directory or $Path *)
Needs["Mathematica2Jupyter`"]

(* Specify the path to your Mathematica notebook *)
notebookPath = "C:\Path\To\Your\Mathematica\Notebooks\Example.nb";

(* Convert the notebook *)
Mathematica2Jupyter[notebookPath]
```

## Notes

*   The conversion process attempts to map Mathematica cell styles (Title, Section, Input, etc.) to appropriate Markdown or code cells in the Jupyter Notebook format.
*   Input cells from Mathematica are converted to Python code cells by default. You may need to manually adjust the code to be valid Python.
*   Some complex or highly customized Mathematica notebook features might not be perfectly translated.
*   The package includes a fix for a known `ExportString` bug that can affect the rendering of TeX fragments containing `$`.

## Inspiration

This package is an minor adaptation of my similar package [Mathematica2VSCode](https://github.com/divenex/mathematica2vscode)
