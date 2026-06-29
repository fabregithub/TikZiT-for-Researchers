[← Index](index.md) | [← Preface](preface.md) | [Next: Installation →](chapter02_installation.md)

# Chapter 1 — Introduction

## What is TikZ?

[TikZ](https://tikz.dev/) is a LaTeX package for drawing vector graphics using a programming
language embedded in your `.tex` source. A diagram is described as text — coordinates, nodes,
and edges — rather than dragged around in a GUI. The payoff: diagrams are version-controllable,
reproducible, and render in the exact fonts/sizes as the rest of your manuscript.

The cost: raw TikZ code is verbose. A ten-box flowchart can be 100+ lines of coordinate
arithmetic.

## What is TikZiT?

[TikZiT](https://tikzit.github.io/) is a small graphical editor purpose-built for TikZ graphs. You
place nodes and draw edges with the mouse; TikZiT writes the TikZ code for you. It does **not**
try to be a general drawing tool (no freehand shapes, no embedded images) — it specifically
targets the "nodes and edges" subset of TikZ that covers flowcharts, graphs, and diagrams. That
narrow focus is exactly what makes it a good fit for STROBE/CONSORT/PRISMA-style figures, which
are fundamentally boxes and arrows.

## TikZiT.app vs. the VS Code extension

| | TikZiT.app (deprecated) | TikZiT for VS Code |
|---|---|---|
| Platform | Standalone macOS/Linux/Windows app | VS Code extension |
| File format | `.tikz` (its own graph format) | Same `.tikz` format |
| Editing model | Mouse-driven canvas is the primary editor; text is secondary | Text editor is primary; a live preview panel renders the graph |
| Styles | `.tikzstyles` files, edited via a GUI dialog | Same `.tikzstyles` files, edited as plain text |
| Maintenance | Discontinued | Actively maintained |

The practical upshot for this book: instead of "drag a node, then check the generated code," the
VS Code workflow is closer to "write or click-place nodes in a `.tikz` file, watch the preview
update." Chapter 3 walks through this concretely.

## Why this matters for publication-quality figures

Several reporting guidelines used across health research *require* a flow diagram, which is why
this handbook leans on them as worked examples:

- **STROBE** — observational study designs (cohort, case-control, cross-sectional)
- **CONSORT** — randomized controlled trials (enrollment → allocation → follow-up → analysis)
- **PRISMA** — systematic reviews and meta-analyses (records identified → screened → included)

But the underlying need isn't specific to health research: any field where a paper has to show
"how did we get from a starting population/sample/dataset to the numbers in the results section"
benefits from the same shape of diagram — a synthesis route with branching yields, a sample
preparation protocol, a computational pipeline with filtering steps, a survey with attrition. If
your field has a named reporting standard with a required diagram (and many do), Chapter 6's
templates are a starting point to adapt; if it doesn't, the same primitives (boxes, branches,
labeled edges) still apply directly to an ad hoc figure.

Journals increasingly expect these as vector graphics, not screenshots of PowerPoint boxes. TikZ
output is vector (PDF/SVG), scales losslessly, and matches your manuscript's font — which is the
main reason to invest in this toolchain rather than a GUI diagramming app.

## Scope of this handbook

This is **not** a complete TikZ reference (see the [TikZ manual](https://tikz.dev/) for that, or
chapter 8 for pointers). It focuses on the diagram types researchers most often need for papers,
theses, and grant applications, taught through the VS Code extension's workflow.

[Next: Chapter 2 — Installation →](chapter02_installation.md)
