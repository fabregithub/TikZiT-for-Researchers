[← Index](index.md) | [← Chapter 2](chapter02_installation.md) | [Next: Styles →](chapter04_styles.md)

# Chapter 3 — First Steps in VS Code

This chapter walks through opening, editing, and previewing a real `.tikz` file:
[`examples/figures/first-flowchart.tikz`](../examples/figures/first-flowchart.tikz). It's a
3-box "eligibility → excluded / enrolled" diagram — the smallest unit a STROBE/CONSORT figure is
built from.

## 1. Anatomy of a `.tikz` file

Open the file. Unlike a typical hand-written TikZ picture, a TikZiT file has a fixed structure:

```latex
\begin{tikzpicture}
    \begin{pgfonlayer}{nodelayer}
        \node [style=box] (0) at (0, 0) {Assessed for eligibility (n=120)};
        \node [style=box] (1) at (0, -2) {Excluded (n=15)};
        \node [style=box] (2) at (0, -4) {Enrolled (n=105)};
    \end{pgfonlayer}
    \begin{pgfonlayer}{edgelayer}
        \draw [style=arrow] (0) to (1);
        \draw [style=arrow] (0) to (2);
    \end{pgfonlayer}
\end{tikzpicture}
```

Three things to notice, since they're the core of how TikZiT differs from plain TikZ:

- **Two layers.** Nodes always live in `pgfonlayer{nodelayer}`, edges in
  `pgfonlayer{edgelayer}`. This is what lets the GUI editor draw edges *behind* nodes reliably.
- **Numbered node names.** `(0)`, `(1)`, `(2)` are arbitrary IDs TikZiT assigns — not meant to be
  meaningful. Edges refer to nodes by these IDs.
- **`style=...` everywhere.** Nodes/edges don't carry inline formatting (colors, line widths).
  Instead they reference a named style (`box`, `arrow`) defined separately in a `.tikzstyles`
  file — see [Chapter 4](chapter04_styles.md). This is the single biggest reason TikZiT diagrams
  stay maintainable: change one style definition, every node using it updates.

## 2. Switching to the graphical editor

By default VS Code opens `.tikz` files as plain text. To get the canvas:

- Command palette (`Cmd+Shift+P`) → **TikZiT: Open TikZ Editor**, or
- Right-click the editor tab → **Reopen Editor With...** → **TikZiT Editor**

You should see the three boxes and two arrows laid out on a grid, matching the coordinates in the
file.

## 3. Loading the style file

The diagram references `style=box` and `style=arrow`, defined in
[`styles/researchflow.tikzstyles`](../styles/researchflow.tikzstyles). There's a sharp edge here worth
knowing up front: **the extension does not let you point the style panel at an arbitrary file.**
It auto-detects styles by scanning the *top level of your open VS Code workspace folder* for a
single `*.tikzstyles` file (and a `*.tikzdefs` file for preamble additions like
`\usetikzlibrary{...}`) — not recursively, and not relative to wherever the `.tikz` file itself
lives.

That means:

1. **Open the repository root as your workspace** (`File > Open Folder...` →
   `TikZiT-for-Researchers/`), not a subfolder. If you open `examples/figures/` directly, the
   extension has nothing to scan for styles.
2. The extension's directory scan does **not** follow symlinks — a symlinked `.tikzstyles` at
   the root is silently skipped (tested: it shows as `FileType.SymbolicLink`, not `FileType.File`,
   so the scan ignores it). So the *real* files have to live at the workspace root:
   `researchflow.tikzstyles` and `researchflow.tikzdefs`. To keep `styles/` as the documented, canonical
   home for project styles without duplicating content, this repo does it the other way around —
   the real files are at the root, and `styles/researchflow.tikzstyles` / `styles/researchflow.tikzdefs`
   are symlinks pointing back up to them (symlinks are fine as long as nothing needs to *scan*
   that directory for them). If you ever copy this project elsewhere, recreate that with:
   ```sh
   ln -s ../researchflow.tikzstyles styles/researchflow.tikzstyles
   ln -s ../researchflow.tikzdefs   styles/researchflow.tikzdefs
   ```
3. Open or refocus `first-flowchart.tikz` in the TikZ Editor. The style panel (right-hand side)
   should now show `box` and `arrow` as swatches instead of "no tikzstyles," and the canvas nodes
   should render as rounded rectangles with arrowheads instead of plain dots/lines.

If the panel still says "no tikzstyles," the most likely cause is that your workspace folder
isn't the repo root — check the breadcrumb path at the top of the editor and reopen the correct
folder if needed.

## 4. Editing on the canvas

With the style panel set, try:

- **Select tool (`s` / `Esc`)** — click a node to select it, drag to move it. Watch the
  underlying text (open the source side-by-side, or `Ctrl+Alt+T` to view TikZ source) update its
  `at (x, y)` coordinate live.
- **Node tool (`n`)** — click empty canvas to drop a new node. It's created with whatever style
  is currently selected in the style panel.
- **Edge tool (`e`)** — click a source node, then a target node, to draw an edge between them.
- **Delete (`Delete` key)** — removes the selected node/edge (and any edges attached to a deleted
  node).

Try adding a fourth box ("Lost to follow-up (n=8)") below "Enrolled," and connect it with an
arrow. This is the same primitive you'll repeat dozens of times building a CONSORT diagram.

## 5. Building and previewing

Two commands, and **they are not chained automatically** — this trips up everyone the first
time:

- **Build TikZ figure** (`Cmd+Alt+B`) — wraps the `.tikz` file in a minimal LaTeX document and
  compiles it to PDF with `pdflatex`, writing `cache/<name>.pdf`. A status-bar spinner reads
  "Building TikZ figure"; if `pdflatex` fails, you'll get an error notification and the log
  opens automatically.
- **Preview TikZ figure** (`Cmd+Alt+V`) — does **not** compile anything. It only opens
  `cache/<name>.pdf` *if it already exists*. Run it before ever building, and it just throws
  `Failed to open PDF file: ENOENT ...` — which looks like a build failure but isn't one.

So the working sequence is always **Build, then Preview**. Run both now on
`first-flowchart.tikz`. If Build itself fails, jump to
[Chapter 9 — Troubleshooting](chapter09_troubleshooting.md) — two prerequisites worth checking
first are a [`tikzit.sty`](../tikzit.sty) file at your workspace root (required for every
`.tikz` file to compile at all) and any TikZ library a style needs (e.g. `shapes.geometric` for
`diamond`, used starting in [Chapter 5](chapter05_flowcharts.md)) being listed in
[`researchflow.tikzdefs`](../researchflow.tikzdefs).

**Also remember the canvas you've been editing in is schematic, not a real renderer** — it draws
every node as a generic circle/label-tag regardless of its actual shape or fill color, and never
draws mid-edge labels. The compiled PDF from Build/Preview is the only accurate picture of what
your manuscript will actually show.

## 6. Where this fits into a real manuscript

`first-flowchart.tikz` is a fragment, not a standalone document — that's intentional. In a real
paper you `\input{}` it inside a `figure` environment:

```latex
\begin{figure}[h]
    \centering
    \input{figures/first-flowchart.tikz}
    \caption{Participant flow.}
    \label{fig:flow}
\end{figure}
```

[`examples/paper.tex`](../examples/paper.tex) shows this end to end, with three embedded
figures. A full walkthrough of everything the host document needs — preamble setup, sizing,
multiple figures, cross-references, and common errors — is in
[Chapter 10 — Integrating into a Real LaTeX Document](chapter10_manuscript_integration.md).

The short version: a fresh `article.cls` document needs four additions before it can
`\input` a TikZiT file:

```latex
\pgfdeclarelayer{nodelayer}
\pgfdeclarelayer{edgelayer}
\pgfsetlayers{main,nodelayer,edgelayer}    % "main" must be included
\input{styles/researchflow.tikzstyles}          % defines style=box, style=arrow, etc.
```

The layer declarations are required because every TikZiT node/edge lives on the `nodelayer`/
`edgelayer` layers; the `main` layer must be listed or content drawn outside those two blocks
silently disappears; the style file `\input` is required because nodes only reference style
*names* (`style=box`), not inline formatting.

[Next: Chapter 4 — Styles →](chapter04_styles.md)
