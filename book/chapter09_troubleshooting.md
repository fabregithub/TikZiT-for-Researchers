[← Index](index.md) | [← Chapter 8](chapter08_advanced_tikz.md) | [Next: Chapter 10 →](chapter10_manuscript_integration.md)

# Chapter 9 — Troubleshooting

## Debugging methodology

Every issue in this chapter was tracked down the same way — not by guessing at fixes, but by a
small set of habits that generalize well beyond TikZ. Worth internalizing before reading the
specific issues below, since they're how you'll find the *next* one too:

1. **Don't trust "it's missing" or "it's not working" — verify with a visible marker.** When the
   lab-protocol template's connecting line appeared to vanish (Chapter 6, §4), the fix wasn't to
   start guessing — it was to paint a literal dot at the exact coordinate in question:
   `\fill [red] (0.west) circle (2pt);`. That turned an ambiguous "I don't see it" into a precise
   "here's exactly where this resolves." The first time this came up, it also caught a
   non-bug: the line had been there the whole time, and what looked like "missing" was just a
   thin line lost in a downscaled image. Verify before fixing.

2. **Isolate by shrinking the reproduction, not by reasoning about the whole file.** When a
   15-node file behaved differently from a working 3-node snippet, the move was to build
   `minimal.tex`, `minimal2.tex`, `minimal3.tex`... each changing exactly one variable (a style,
   a piece of text, a node count) from the last. When a 3-node version with one bordered box
   broke but an otherwise-identical all-`substep` version didn't, that isolated the cause to one
   specific style property — not "something in the file."

3. **When two things should behave identically but don't, let the rendered output correct your
   model, not the other way around.** Don't defend a theory about how an anchor or a layer
   *should* behave; check what it actually does, and update the theory.

4. **For draw-order ("why is X on top of/behind Y") bugs specifically: remember layers are
   global, source order is only local *within* a layer.** This was the crux of getting the
   lab-protocol spine to draw behind its boxes (Chapter 6, §4) — `\pgfsetlayers{nodelayer,
   edgelayer}` fixes which named layer wins *regardless* of where each block sits in the file.
   No amount of reordering text within `edgelayer` could ever put something behind `nodelayer`
   content; only moving the draw call into the same layer it needed to hide behind could.

5. **Validate against the real compiler, not your mental model of TikZ.** Every claim in this
   chapter — a property is allowed, an anchor resolves somewhere specific, something is now
   actually hidden — was checked by running `pdflatex` and looking at the resulting pixels
   (often at high DPI, cropped tight on the area in question), not by reasoning from memory about
   how TikZ "should" behave.

Confirmed issues, found while writing this handbook:

- **Style panel says "no tikzstyles" even though a `.tikzstyles` file exists in the project.**
  Two separate causes, both confirmed while writing this handbook:
  1. The extension only scans the *top level of the open VS Code workspace folder* for a single
     `*.tikzstyles`/`*.tikzdefs` file — not recursively, and not relative to the `.tikz` file's
     own directory. Fix: open the repo root as your workspace.
  2. The scan does **not** follow symlinks — a symlinked `.tikzstyles` at the root is skipped.
     The real file must physically exist at the workspace root. This project keeps the real
     files there (`researchflow.tikzstyles`, `researchflow.tikzdefs`) and symlinks *from* `styles/` back
     up to them, not the other way around. See
     [Chapter 3, §3](chapter03_first_steps.md#3-loading-the-style-file).

- **Style file is detected (filename shows in the panel) but the panel shows zero style swatches.**
  The `.tikzstyles` parser is a small custom lexer, not a general TeX parser — a backslash
  command anywhere inside a style's `[...]` (e.g. `font=\small`) makes the *whole file* fail to
  parse, silently, with no error shown. Fix: remove TeX macros from style property values. See
  [Chapter 4](chapter04_styles.md#constraints-confirmed-while-building-this-handbook) for the
  full character-set constraint.

- **`Package pgf Error: Sorry, the requested layer 'nodelayer' could not be found`** when
  compiling a manuscript that `\input`s a `.tikz` file directly with plain `pdflatex` (outside
  the VS Code preview). Fix: declare the layers in your document's own preamble:
  ```latex
  \pgfdeclarelayer{nodelayer}
  \pgfdeclarelayer{edgelayer}
  \pgfsetlayers{nodelayer,edgelayer}
  ```
  The extension's own preview command injects this for you; a manuscript preamble has to do it
  manually. See [Chapter 3](chapter03_first_steps.md#6-where-this-fits-into-a-real-manuscript).

- **`Package pgfkeys Error: I do not know the key '/tikz/box'`** → the `.tikz` file references a
  style (`style=box`) that hasn't been `\input` into the document. Add
  `\input{styles/researchflow.tikzstyles}` (or whichever `.tikzstyles` file defines it) before
  `\input`-ing the figure.

- **Canvas shows plain circles for every node, ignores fill colors, and doesn't show edge
  labels at all — even though styles are loaded correctly.** This is expected: the `.tikz`
  editor's canvas is a schematic view, not a real TikZ renderer. The small circle is always
  drawn at a node's anchor point regardless of its `shape=` property; the yellow dashed box
  around a label is just the editable label tag, not the node's real shape; and mid-edge labels
  (`to node {...}`) aren't drawn on the canvas at all. None of this reflects the compiled output.
  Always judge actual appearance — shapes, fills, edge labels — from the compiled PDF (**Build**,
  then **Preview**; see the entry below), not from the canvas.

- **`Cmd+Alt+V` ("Preview TikZ figure") throws `Failed to open PDF file: ENOENT ...cache/<name>.pdf`
  even right after editing a figure, with no build error shown.** Traced directly in the
  extension's command bindings: **Preview does not compile anything.** It only checks whether
  `cache/<name>.pdf` already exists and opens it if so; if not, it throws this exact error
  immediately. Compiling is a separate command — **Build TikZ figure** (`Cmd+Alt+B`). Run Build
  first (a status-bar spinner reads "Building TikZ figure"; it'll show "build exited with error"
  and open the log if `pdflatex` actually fails), *then* Preview to open the result. The two
  commands are not chained automatically.

- **Content drawn outside an explicit `pgfonlayer` block silently disappears — no error, just a
  blank page (or a page missing exactly that content).** Root cause: `tikzit.sty`'s
  `\pgfsetlayers{nodelayer,edgelayer}` didn't include `main`, pgf's own default layer — and once
  you customize `\pgfsetlayers` at all, anything not in the list simply never gets drawn. This
  silently broke a `\foreach`-generated set of nodes the first time they were written outside a
  `pgfonlayer` block, and separately broke `pgfplots`' `axis` environment outright (confirmed in
  total isolation, no TikZiT involvement) since it draws via the default layer internally. Fixed
  project-wide in [`tikzit.sty`](../tikzit.sty) by adding `main` to the layer list — verified
  against every existing template/example with no regressions (identical PNG output
  before/after). If you ever hand-write your own `tikzit.sty` for another project, include `main`
  from the start. See [Chapter 8](chapter08_advanced_tikz.md#a-real-bug-this-chapter-surfaced--and-a-project-wide-fix).

- **A diagonal edge silently passes straight through an unrelated box, with no error.**
  [`first-flowchart.tikz`](../examples/figures/first-flowchart.tikz) originally stacked three
  nodes in a single vertical line; the direct edge between the first and third drew straight
  through the second node's box, since TikZ draws edges as straight segments between anchors with
  no awareness of other nodes sitting on that line. See
  [Chapter 5, §2](chapter05_flowcharts.md#2-layout-strategy) for the fix (move the branch off the
  main trunk's line).

- **A curved edge (`bend left=`/`bend right=`) overlaps an unrelated node, with no error.** Same
  underlying cause as the entry above, different shape: TikZ draws exactly the curve you specify
  with no awareness of other nodes near its path. Hit directly while building
  [`cookbook-curved-edge.tikz`](../examples/figures/cookbook-curved-edge.tikz) — a `bend left=30`
  feedback edge's bulge swung low enough to sit on top of an unrelated box. Fix: check what's
  under a curve's bulge (not just its straight-line endpoints), reduce the bend angle, and/or
  reposition the node. See [Chapter 7, §1](chapter07_cookbook.md#1-curvedfeedback-edges--and-a-pitfall-with-the-bend-direction).

- **`dvisvgm --pdf` fails with `ERROR: can't retrieve number of pages from file ...`, even on a
  trivial one-line PDF unrelated to TikZ.** This breaks the extension's built-in **Build TikZ
  figure as SVG** command, since it shells out to `dvisvgm` by default. Confirmed on this
  project's machine: a plain MacTeX-bundled `dvisvgm` (statically linked, no dynamic poppler
  dependency per `otool -L`) fails this way unconditionally in `--pdf` mode, regardless of input.
  Rather than debug a specific `dvisvgm` build, this repo's
  [`scripts/build-all.sh`](../scripts/build-all.sh) bypasses it entirely, using `pdftocairo -svg`
  for SVG export instead (reliable, ships with `poppler`). Note `pdftocairo` is **not** a
  drop-in replacement inside the extension's own SVG command setting — the extension always
  appends its output filename as `-o <file>`, which `pdftocairo` interprets as "print only odd
  pages," not "write to this file." See [Chapter 7, §3](chapter07_cookbook.md#3-exporting-to-pdf-png-and-svg-without-the-vs-code-extension).

Known issues to document once confirmed:
- Preview/build fails with "undefined control sequence" → missing `\usetikzlibrary{...}` for a
  library used by a style (e.g. `arrows.meta`) — add it to a `.tikzdefs` file and set it as
  active in the style panel (see [`styles/researchflow.tikzdefs`](../styles/researchflow.tikzdefs))
- Nodes render as plain dots in the editor canvas → style file not loaded/selected in the style
  panel
- **`Failed to open PDF file: Error: ENOENT ... cache/<name>.pdf`, with the `cache/` directory
  empty afterward (no log, no leftover `.tex`).** The real cause, traced by reading the
  extension's own build code (`dist/extension.js`): Build/Preview generates a wrapper document
  and only inserts the required `\pgfdeclarelayer{nodelayer}` / `\pgfdeclarelayer{edgelayer}` /
  `\pgfsetlayers{...}` lines **if a file literally named `tikzit.sty` exists at the workspace
  root.** If it's missing, the extension just shows a one-line warning
  (`Warning: tikzit.sty not found in workspace`) — easy to miss — and proceeds to compile anyway,
  without the layer declarations, which fails immediately on every TikZiT file's
  `\begin{pgfonlayer}{nodelayer}` (every TikZiT file has one). Compile failures clean up their own
  temp files, so nothing is left behind to inspect — hence the empty `cache/`. Fix: add a minimal
  `tikzit.sty` at the workspace root that declares the two layers and a `tikzfig` style key (the
  extension references `\tikzstyle{every picture}=[tikzfig]` when it finds this file). See
  [`tikzit.sty`](../tikzit.sty) in this repo — copy it as-is into any new TikZiT project's root.

  Unrelated false lead worth recording: this looked at first like a `PATH` problem (VS Code GUI
  apps don't always inherit a terminal's `PATH`, so an unqualified `pdflatex` in
  `vstikzit.texCommand` can fail to resolve). That's a real, separate thing worth pinning
  defensively — see [`.vscode/settings.json`](../.vscode/settings.json) — but it was not the
  actual cause here; the missing `tikzit.sty` was.

[Next: Appendix →](appendix.md)
