[← Index](index.md) | [← Chapter 4](chapter04_styles.md) | [Next: Templates →](chapter06_templates.md)

# Chapter 5 — Flowcharts

Chapters 3–4 covered process boxes (`include`/`exclude`) and plain arrows. This chapter adds the
other primitive every flowchart guideline needs — a decision point with labeled branches — and
covers layout habits that keep diagrams readable as they grow past 3–4 boxes.

## 1. A decision diamond with labeled branches

[`examples/figures/decision-example.tikz`](../examples/figures/decision-example.tikz):

```latex
\begin{tikzpicture}
    \begin{pgfonlayer}{nodelayer}
        \node [style=include] (0) at (0, 0) {Screened (n=200)};
        \node [style=decision] (1) at (0, -2.5) {Meets inclusion criteria?};
        \node [style=include] (2) at (4, -5) {Enrolled (n=150)};
        \node [style=exclude] (3) at (-4, -5) {Excluded (n=50)};
    \end{pgfonlayer}
    \begin{pgfonlayer}{edgelayer}
        \draw [style=arrow] (0) to (1);
        \draw [style=arrow] (1) to node [style=edgelabel] {Yes} (2);
        \draw [style=arrow] (1) to node [style=edgelabel] {No} (3);
    \end{pgfonlayer}
\end{tikzpicture}
```

Two new styles, added to [`epiflow.tikzstyles`](../epiflow.tikzstyles) in Chapter 4's pattern:

```latex
\tikzstyle{decision}=[draw=black, fill=yellow!10, diamond, aspect=2, align=center, inner sep=1pt]
\tikzstyle{edgelabel}=[fill=white, inner sep=1pt]
```

`decision` is a node style like `include`/`exclude`, just with `shape=diamond` instead of
`rectangle`. `edgelabel` is also a *node* style (not an edge style — it has no arrow-direction
key, so TikZiT's style panel correctly sorts it into the node row) — it's placed **mid-edge**
using TikZ's `to node {...}` syntax, which TikZiT's `.tikz` format supports natively:

```latex
\draw [style=arrow] (1) to node [style=edgelabel] {Yes} (2);
```

The `fill=white` on `edgelabel` matters: without it, the arrow line is drawn straight through the
"Yes"/"No" text, which looks broken once compiled.

**Note:** `diamond` requires `\usetikzlibrary{shapes.geometric}`, already added to
[`epiflow.tikzdefs`](../epiflow.tikzdefs) (for the editor preview) and
[`examples/paper.tex`](../examples/paper.tex) (for the real manuscript build) — see Chapter 9 if
you add a new shape/library and forget one of the two.

A cosmetic note from actually compiling this: long question text in a `diamond` node (e.g. "Meets
inclusion criteria?") tends to produce `Overfull \hbox` / `Underfull \hbox` warnings from LaTeX —
harmless, but if you want to silence them, either shorten the label or add a `text width=...` key
to the `decision` style to force a line break.

## 2. Layout strategy

A few habits that scale better as diagrams grow past a handful of boxes:

- **Never stack three nodes in a straight line if the first and last are also connected
  directly.** [`first-flowchart.tikz`](../examples/figures/first-flowchart.tikz) originally had
  `Assessed`, `Excluded`, `Enrolled` all at `x=0`, stacked vertically. The straight edge from
  `Assessed` to `Enrolled` is a vertical line — and `Excluded` sat exactly on that line, so the
  arrow visibly struck through its box. TikZ draws each edge as the straight segment between two
  node anchors; it has no awareness of other nodes that happen to sit on that segment, so nothing
  warns you about this. The fix used here matches `decision-example.tikz`'s pattern: keep the
  main trunk (`Assessed` → `Enrolled`) on one vertical line, and move the *branch* (`Excluded`)
  off to the side (`x=4`) so it's never collinear with a different edge.
- **Keep a consistent grid step.** This example uses whole-unit coordinates (`-2.5`, `-5`, `±4`)
  rather than free-hand placement — easier to keep spacing uniform, and easier to read the raw
  `.tikz` source later.
- **One flow direction.** Top-to-bottom for the main path, branches splitting left/right at
  decision points (as above) — avoid mixing top-to-bottom and left-to-right in the same diagram
  unless it's a deliberate multi-column layout (see below).
- **Don't let edges cross if you can avoid it.** If two edges would cross, it's often a sign the
  node layout, not the edge routing, needs to change — reposition nodes before reaching for
  curved edges.
- **Reserve color for meaning, not decoration.** `include`/`exclude` (blue/red) should mean the
  same thing in every figure across a project. If you introduce a third color, give it an
  equally consistent meaning (e.g. yellow = a decision/assessment point, as used here).

## 3. Multi-column layouts

For side-by-side group comparisons (e.g. intervention vs. control arms in a CONSORT diagram),
extend the *x*-coordinate rather than nesting separate `tikzpicture`s — this keeps edges that
need to cross between arms (e.g. a shared "Randomized" box splitting into two arms) simple to
draw, since every node lives in one coordinate system. Chapter 6's CONSORT template builds on
exactly this pattern: one shared trunk down the middle, two columns branching out from it.

[Next: Chapter 6 — Templates →](chapter06_templates.md)
