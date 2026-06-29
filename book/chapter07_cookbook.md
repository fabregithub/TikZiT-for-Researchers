[← Index](index.md) | [← Chapter 6](chapter06_templates.md) | [Next: Advanced TikZ →](chapter08_advanced_tikz.md)

# Chapter 7 — Cookbook

Short, copy-pasteable recipes, each compiled and checked while writing this chapter — including
one real bug along the way (see §1).

## 1. Curved/feedback edges — and a pitfall with the bend direction

[`examples/figures/cookbook-curved-edge.tikz`](../examples/figures/cookbook-curved-edge.tikz)
shows a feedback loop ("Re-screened later," looping back to "Assessed for eligibility") that
can't be a straight line without crossing the main trunk — TikZ's `bend left=<angle>` /
`bend right=<angle>` edge properties curve the line instead:

```latex
\draw [style=arrow, bend left=20] (1) to node [style=edgelabel, sloped] {if re-contacted} (3);
\draw [style=arrow, bend right=20] (3) to (0);
```

`bend left`/`bend right` are relative to the edge's direction of travel, not the page — `(1) to
(3)` travels right-to-left, so "left" of that direction bulges the curve *downward*. `sloped` on
the `edgelabel` node rotates the label text to follow the curve's angle at its midpoint, instead
of staying horizontal.

**The pitfall, hit directly while building this example:** the first version used `bend left=30`
with a fairly large angle, and placed the "Enrolled" node directly below the curve's path. The
curve's bulge swung low enough to overlap "Enrolled" entirely — both the curve and its label sat
on top of the node, with no error or warning from LaTeX (TikZ has no concept of "avoid this other
node," it just draws the geometric curve you asked for). The fix was two-part: lower `Enrolled` to
clear the curve's sag, and reduce the bend angle from 30° to 20° (a smaller angle means a shallower
bulge). General rule: when adding a curved edge, check what's *underneath* the curve's bulge, not
just along the straight line between its endpoints — bulge depth grows with both the bend angle
and the distance between the two nodes.

## 2. Sample-size annotations without cluttering the main label

Two options, both already used elsewhere in this handbook:

- **Inline, inside the box** — append `(n=X)` directly to the node's label text, as every
  template in Chapter 6 does (`Excluded (n=50)`). Simplest, and keeps the count visually tied to
  the box it describes.
- **On the edge itself** — use a `to node [style=edgelabel] {...}` mid-edge label (Chapter 5 §1)
  when the count describes the *transition*, not either endpoint — e.g. "n=10 re-contacted"
  on the curved edge above, rather than awkwardly splitting it across both boxes' labels.

Avoid a third option that seems tempting but causes real layout problems: a separate small
annotation node floating *near* a box but not connected to it by an edge. Nothing pins it in
place relative to the box if you ever move the box, and (per §1) nothing stops it from silently
overlapping another node either.

## 3. Exporting to PDF, PNG, and SVG without the VS Code extension

The extension's own **Build TikZ figure as SVG** command depends on `dvisvgm`, and on at least
one real machine tested while writing this handbook, `dvisvgm --pdf` fails outright — even on a
trivial one-line PDF, unrelated to TikZ:

```
$ dvisvgm --pdf hello-world.pdf -o out.svg
ERROR: can't retrieve number of pages from file hello-world.pdf
```

Rather than fight a specific `dvisvgm` build, [`scripts/build-all.sh`](../scripts/build-all.sh)
sidesteps it: it builds the same wrapper document the extension does (`tikzit.sty` +
`epiflow.tikzstyles` + `epiflow.tikzdefs`) directly with `pdflatex`, then converts the resulting
PDF with `pdftocairo -svg` (reliable, ships with `poppler`) and `pdftoppm -png` (for raster
previews — e.g. embedding a figure in a Slack message or a slide deck where PDF isn't convenient).

## 4. Batch-building every template and example

```sh
bash scripts/build-all.sh
```

Compiles every `.tikz` file under `templates/*/` and `examples/figures/` and writes
`images/<name>.pdf`, `images/<name>.svg`, and `images/<name>.png` (150 DPI) for each. Useful
for regenerating every figure at once after a shared style change (e.g. after editing
`epiflow.tikzstyles`, to sanity-check nothing broke project-wide) — see
[`images/`](../images/) for the current output. Requires `pdflatex`, `pdftocairo`, and
`pdftoppm` on `PATH`; the script resolves all paths relative to its own location, so it can be
run from any working directory.

[Next: Chapter 8 — Advanced TikZ →](chapter08_advanced_tikz.md)
