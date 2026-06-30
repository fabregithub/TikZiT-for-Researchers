[← Index](index.md) | [← Chapter 3](chapter03_first_steps.md) | [Next: Flowcharts →](chapter05_flowcharts.md)

# Chapter 4 — Styles

This chapter walks through editing styles two ways — via the GUI Style Editor, and by hand-editing
[`researchflow.tikzstyles`](../researchflow.tikzstyles) — and uses both to build an inclusion/exclusion color
convention for flowchart boxes, the kind of thing you'll reuse across every template in
[Chapter 6](chapter06_templates.md).

## 1. Opening the Style Editor

Open `researchflow.tikzstyles` in VS Code. It opens in TikZiT's custom Style Editor (not plain text) —
a form with **+ Node Style** / **+ Edge Style** buttons, a field set (`name`, `draw`, `fill`,
`tikzit draw`, `tikzit fill`, `shape`, `tikzit shape`), and **Apply** / **Reset** / **Edit** /
**Delete** buttons. The swatches on the right preview every style currently defined.

## 2. Field meanings

Most fields are literal TikZ properties:

| Field | Meaning |
|---|---|
| `name` | The style's identifier — what `style=...` refers to in a `.tikz` file |
| `draw` | TikZ `draw=` color (the outline) |
| `fill` | TikZ `fill=` color |
| `shape` | TikZ node shape (`rectangle`, `circle`, etc.) |

`tikzit draw` / `tikzit fill` / `tikzit shape` are **editor-only overrides** — if your real
`draw`/`fill`/`shape` reference something the simple canvas renderer can't evaluate (a complex
color expression, a custom shape macro), these three let the canvas preview look reasonable
without changing what actually gets typeset in your manuscript's PDF. Leave them blank unless you
hit that specific problem.

## 3. Editing an existing style

Click the `include` swatch, change `draw` to `blue!60!black` and `fill` to `blue!10`, click
**Apply**. The swatch updates immediately, and the change lands directly in
`researchflow.tikzstyles` as text:

```latex
\tikzstyle{include}=[draw=blue!60!black, rectangle, rounded corners, align=center, minimum width=4cm, minimum height=1cm, fill=blue!10]
```

## 4. Creating a new style — and a pitfall

Click **+ Node Style** to add a new style, rename it via the `name` field, and set its `draw`/
`fill`. There's a sharp edge here: **a new style starts completely blank** — it does *not*
inherit the shape/sizing properties (`rectangle`, `rounded corners`, `align=center`,
`minimum width=...`, `minimum height=...`) from any other style. If you only set `draw`/`fill`
on a new style meant to be "the same box shape, different color," it will render as a tiny
default TikZ node, not a box — easy to miss in the swatch preview at small size.

The fix is to copy the full property list, not just the color, between related styles:

```latex
\tikzstyle{include}=[draw=blue!60!black, rectangle, rounded corners, align=center, minimum width=4cm, minimum height=1cm, fill=blue!10]
\tikzstyle{exclude}=[draw=red!60!black, rectangle, rounded corners, align=center, minimum width=4cm, minimum height=1cm, fill=red!10]
```

This `.tikzstyles` format has no inheritance/mixin mechanism (unlike plain TikZ's `\tikzset` with
style composition) — every style is a fully independent, flat property list. For a project with
many related box variants, hand-editing the text (duplicate a line, change the color) is often
faster and less error-prone than the **+ Node Style** button.

## 5. A convention for retained/removed items in a flow

`include`/`exclude` (blue/red) gives a simple, colorblind-checkable convention for any diagram
that tracks items moving through stages of a process: boxes for what continues vs. what gets
removed. In a participant-flow diagram that's people remaining vs. people excluded — but the same
pair works unchanged for filtered-out records in a pipeline, discarded candidates in a screening
process, or failed runs in an experiment; rename the styles if "include"/"exclude" doesn't fit
your domain's vocabulary, the colors and meaning carry over regardless. This is
used in [`first-flowchart.tikz`](../examples/figures/first-flowchart.tikz) — the "Excluded" box
now uses `style=exclude`, the others `style=include`. A third, neutral `process` style (grey, no
inclusion/exclusion meaning) was added in Chapter 6 for steps like "Randomized" or "Records
screened" that are neither an inclusion nor exclusion outcome — just a count at a pipeline stage.
Chapter 6's STROBE/CONSORT/PRISMA templates build on all three node styles plus a plain `arrow`
edge style, so a single shared `researchflow.tikzstyles` file keeps every diagram's color language
consistent. Chapter 6's lab-protocol template adds a fourth visual family entirely — left-anchored
`stage`/`substep` boxes and a borderless `spine` edge style — for step-by-step method diagrams
rather than participant-flow diagrams; see Chapter 6 §4 for why that one needs `anchor=west`, and
why its connecting line runs through invisible helper nodes rather than the visible boxes
themselves.

## Constraints confirmed while building this handbook

The VS Code extension parses `.tikzstyles` with a small custom lexer, not a general TeX parser.
Two practical limits fell out of hitting this directly:

- **No backslash commands inside `[...]`.** Property values inside a style's brackets are
  matched against a restricted character set (letters, digits, `< > - ' . !`) — no `\`. A style
  like `[..., font=\small]` causes the *entire file* to fail to parse silently (the style panel
  shows the filename but zero swatches for any style, not just the broken one). Keep style
  bodies to plain key/value pairs without TeX macros; do font sizing elsewhere (e.g. in the
  surrounding manuscript, not the style).
- **Edge vs. node style is inferred from the arrow-direction key.** A style is classified as an
  *edge* style only if its bracket list contains one of the literal keys `-`, `->`, `-|`, `<-`,
  `<->`, `<-|`. A more elaborate arrow spec like `-{Latex[length=2.5mm]}` (valid TikZ, and also
  invalid here for the same nested-bracket/backslash-free reason above) won't be recognized as
  an edge style and won't sort into the edge-style swatch row. Use the plain `->` form if you
  want TikZiT's panel to categorize it correctly; reserve fancier `arrows.meta` tips for chapter
  8's hand-edited TikZ, outside what the GUI panel needs to understand.

[`researchflow.tikzstyles`](../researchflow.tikzstyles) at the repo root reflects both constraints.

[Next: Chapter 5 — Flowcharts →](chapter05_flowcharts.md)
