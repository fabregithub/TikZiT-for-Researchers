[← Index](index.md) | [← Chapter 1](chapter01_introduction.md) | [Next: First Steps →](chapter03_first_steps.md)

# Chapter 2 — Installation

## 1. VS Code

Install [VS Code](https://code.visualstudio.com/) (1.126+ as used in this book).

## 2. A LaTeX distribution

You need `pdflatex` (or `lualatex`/`xelatex`) on your `PATH` so the extension can compile previews.
On macOS, install [MacTeX](https://www.tug.org/mactex/). Verify with:

```sh
which pdflatex lualatex xelatex
```

If these resolve to paths like `/Library/TeX/texbin/pdflatex`, you're set.

## 3. The TikZiT extension

Install **TikZiT** by Aleks Kissinger from the VS Code Marketplace (extension id
`alekskissinger.vstikzit`). Confirm it's installed:

```sh
code --list-extensions | grep -i tikz
# alekskissinger.vstikzit
```

This single extension provides everything: a `.tikz` graph editor, syntax highlighting for
`.tikz`/`.tikzstyles`/`.tikzdefs` files, and build/preview commands — there is no separate
"TikZ" extension needed alongside it.

## 4. `tikzit.sty`

Place a copy of this repo's [`tikzit.sty`](../tikzit.sty) at the root of any TikZiT project. The
extension's Build/Preview commands only declare the `nodelayer`/`edgelayer` layers that every
`.tikz` file depends on if a file with that exact name exists at the workspace root — otherwise
it shows an easy-to-miss one-line warning and the build fails on every figure. See
[Chapter 9](chapter09_troubleshooting.md) for how this was diagnosed.

## 5. Relevant settings

Open VS Code settings (`Cmd+,`) and search `vstikzit`. The ones worth knowing about now:

| Setting | Purpose |
|---|---|
| `vstikzit.texCommand` | Command used to compile previews (default: `pdflatex`) |
| `vstikzit.texCommandArgs` | Arguments passed to that command |
| `vstikzit.pdfOutputDir` | Where preview/sync PDFs are written |
| `vstikzit.svgOutputDir` | Where SVG exports are written |

The defaults work out of the box with a standard MacTeX install — leave them alone for now;
chapter 9 (Troubleshooting) revisits them if compilation fails.

## 6. Sanity check

1. In VS Code, create a new file `test.tikz`.
2. It should open in a plain text editor by default. Right-click the tab (or use the command
   palette: `Cmd+Shift+P` → "Open TikZ Editor") to switch to the graphical editor.
3. You should see an empty grid canvas. That confirms the extension is active.

If step 2/3 doesn't work, re-check `code --list-extensions` and restart VS Code.

[Next: Chapter 3 — First Steps in VS Code →](chapter03_first_steps.md)
