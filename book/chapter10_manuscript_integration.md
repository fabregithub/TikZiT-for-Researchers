[← Index](index.md) | [← Chapter 9](chapter09_troubleshooting.md) | [Next: Appendix →](appendix.md)

# Chapter 10 — Integrating TikZiT Figures into a Real LaTeX Document

The TikZiT VS Code extension is great for drawing and iterating on a diagram, but
the diagram itself is just a `.tikz` fragment — a `tikzpicture` environment with no
preamble, no `\documentclass`, and no package declarations. This chapter walks through
everything you need to embed that fragment into a real LaTeX manuscript, from copying a
template out of this repo to a compilable paper with numbered figures.

The full working example lives at [`examples/paper.tex`](../examples/paper.tex).

---

## 1. What a `.tikz` file needs from its host document

Every TikZiT-generated `.tikz` file uses:

1. **The `tikz` package** — `\usepackage{tikz}` (required for any TikZ content).
2. **TikZ libraries** — any `\usetikzlibrary{...}` that your styles reference, e.g.
   `arrows.meta`, `shapes.geometric`, `positioning`, `calc`. These are listed in your
   project's [`researchflow.tikzdefs`](../researchflow.tikzdefs).
3. **Two named layers** — every TikZiT file wraps nodes in `pgfonlayer{nodelayer}` and
   edges in `pgfonlayer{edgelayer}`. The host document must declare these layers before
   any `.tikz` file is `\input`, and must include pgf's default `main` layer in the
   layer order or any content drawn outside those two blocks silently disappears:

   ```latex
   \pgfdeclarelayer{nodelayer}
   \pgfdeclarelayer{edgelayer}
   \pgfsetlayers{main,nodelayer,edgelayer}
   ```

4. **Your style definitions** — nodes only reference style *names* (`style=include`,
   `style=arrow`); the actual formatting comes from `\input`-ing your `.tikzstyles` file.

None of this is in a typical `article.cls` skeleton. Miss any one of them and `pdflatex`
either fails outright or silently renders nothing (the layer omission case is the worst
because the document compiles cleanly but the figure is blank).

---

## 2. Starting from a template

The fastest way to get a correctly configured preamble is to copy
[`examples/paper.tex`](../examples/paper.tex) and edit from there. It already has
all four requirements wired up. The key preamble section is:

```latex
\documentclass{article}
\usepackage{tikz}
\usetikzlibrary{arrows.meta}
\usetikzlibrary{shapes.geometric}
\usetikzlibrary{positioning}
\usetikzlibrary{calc}

% Layer declarations — required before \input-ing any TikZiT-produced .tikz file.
% "main" must be listed explicitly or content drawn outside nodelayer/edgelayer
% silently fails to render (see Chapter 9 for the full explanation).
\pgfdeclarelayer{nodelayer}
\pgfdeclarelayer{edgelayer}
\pgfsetlayers{main,nodelayer,edgelayer}

\input{styles/researchflow.tikzstyles}
```

When starting a new paper in a different directory, the only things to adjust are:

- The `\usetikzlibrary{...}` list — match whatever is in your project's `.tikzdefs`
  file. (The safest approach is to just copy the full list from `researchflow.tikzdefs`.)
- The `\input` path to your `.tikzstyles` file — make it relative to where your
  `.tex` file lives.

---

## 3. Copying a template diagram into your project

Pick whichever template is closest to your use case (STROBE, CONSORT, PRISMA, or
lab-protocol) from the `templates/` directory and copy it into your paper's figures
folder:

```sh
cp templates/strobe/strobe-template.tikz myproject/figures/participant-flow.tikz
```

Then open it in VS Code (with the repo root as your workspace), edit on the canvas,
and build with `Cmd+Alt+B` to check the output before embedding it in the paper.

---

## 4. Embedding a figure

Use a standard `figure` environment with `\input{}` pointing to your `.tikz` file:

```latex
\begin{figure}[htbp]
    \centering
    \input{figures/participant-flow.tikz}
    \caption{Participant flow through the study.}
    \label{fig:flow}
\end{figure}
```

The path in `\input{}` is always relative to the `.tex` file, not to the project root.
So if your manuscript is at `myproject/paper.tex` and the diagram is at
`myproject/figures/participant-flow.tikz`, the `\input` path is just
`figures/participant-flow.tikz`.

Cross-reference it in the text the usual way:

```latex
Participant flow is shown in Figure~\ref{fig:flow}.
```

---

## 5. Controlling figure size

TikZiT places nodes at grid coordinates (e.g. `(0, 0)`, `(0, -2)`), so the physical
size of the rendered figure depends on the scale TikZ uses. The default is usually
fine, but for large diagrams you have three options:

**Option A — `scale` key on the `tikzpicture` (safest):**

```latex
\begin{figure}[htbp]
    \centering
    \begin{tikzpicture}[scale=0.75]
        \input{figures/participant-flow.tikz}
    \end{tikzpicture}
    \caption{Participant flow.}
    \label{fig:flow}
\end{figure}
```

> **Note:** This wraps the `\input` inside an *outer* `tikzpicture` that carries the
> `scale` key. The `.tikz` file itself already begins with `\begin{tikzpicture}`, so
> this nests one picture inside another — which TikZ allows. The inner coordinates are
> unchanged; only the outer rendering is scaled.
> A cleaner alternative (if you own the `.tikz` file) is to add `scale=0.75` directly
> to the `\begin{tikzpicture}` inside the `.tikz` file itself.

**Option B — `\scalebox` (scales everything including fonts):**

```latex
\scalebox{0.75}{\input{figures/participant-flow.tikz}}
```

**Option C — `\resizebox` (fits to a fixed width):**

```latex
\resizebox{\columnwidth}{!}{\input{figures/participant-flow.tikz}}
```

`\resizebox` is useful for two-column journals where you want the figure to fill the
column width exactly. The `!` in the second argument keeps the aspect ratio.

---

## 6. Multiple figures in one paper

Just add more `figure` environments — one per diagram:

```latex
\begin{figure}[htbp]
    \centering
    \input{figures/first-flowchart.tikz}
    \caption{Participant flow.}
    \label{fig:flow}
\end{figure}

\begin{figure}[htbp]
    \centering
    \input{figures/decision-example.tikz}
    \caption{Eligibility screening with a labeled decision branch.}
    \label{fig:decision}
\end{figure}
```

All figures share the same preamble declarations (layer declarations, style `\input`)
— you only write those once, no matter how many `.tikz` files you embed.

See [`examples/paper.tex`](../examples/paper.tex) for a complete working example with
three figures from this handbook.

---

## 7. Building the document

Compile with `pdflatex` as you would any LaTeX document:

```sh
cd examples
pdflatex paper.tex
```

Two passes are normally enough to resolve `\ref` cross-references. If you use
`\label`/`\ref` for figures, run `pdflatex` twice:

```sh
pdflatex paper.tex && pdflatex paper.tex
```

**Expected output files** (all safe to `.gitignore`):

| File | What it is |
|------|-----------|
| `paper.pdf` | The compiled document — the one you want |
| `paper.aux` | Cross-reference data (used across passes) |
| `paper.log` | Full compiler log — first place to look if something fails |
| `paper.synctex.gz` | Editor source-sync data (used by SyncTeX-aware editors) |

The project's `.gitignore` already excludes all of these except `paper.tex` itself.

---

## 8. When `tikzit.sty` is and isn't needed

`tikzit.sty` at the workspace root is required by the **TikZiT VS Code extension's
Build/Preview commands** — the extension wraps each `.tikz` file in a minimal document
and `\RequirePackage{tikzit}` expects to find it there. Without it, every in-editor
Build fails.

Your **own manuscript** (`paper.tex`) does *not* `\usepackage{tikzit}` — it declares
layers and inputs styles directly, which is exactly what `tikzit.sty` does under the
hood. So you don't need `tikzit.sty` to compile `paper.tex` with `pdflatex` directly;
you only need the four items in section 1 above.

The distinction matters if you move or copy your manuscript to a machine without this
repo: `paper.tex` compiles fine anywhere with a standard TeX installation, but the
VS Code Build command won't work without `tikzit.sty` present at the workspace root.

---

## 9. Common errors and fixes

| Symptom | Most likely cause | Fix |
|---------|-------------------|-----|
| `Undefined control sequence \begin{pgfonlayer}` | `\usepackage{tikz}` missing | Add it to the preamble |
| `Undefined control sequence \pgfdeclarelayer` | TikZ loaded but layer declaration missing | Add the three `\pgfdeclarelayer`/`\pgfsetlayers` lines |
| Figure compiles but is completely blank | `main` omitted from `\pgfsetlayers` | Use `\pgfsetlayers{main,nodelayer,edgelayer}` |
| `Undefined control sequence \style=...` | `.tikzstyles` file not `\input` | Add `\input{path/to/researchflow.tikzstyles}` |
| `File '...' not found` on `\input{figures/...}` | Wrong relative path | Run `pdflatex` from the same directory as your `.tex` file, or use an absolute path |
| `Undefined control sequence \node [style=diamond]` | `shapes.geometric` library missing | Add `\usetikzlibrary{shapes.geometric}` |

For a deeper dive into diagnosing blank figures and silent failures, see
[Chapter 9 — Troubleshooting](chapter09_troubleshooting.md).

---

[Next: Appendix →](appendix.md)
