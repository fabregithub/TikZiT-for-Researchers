# TikZiT for Researchers

**Scientific Diagrams and Flowcharts with TikZiT and TikZ: A Practical Guide for Researchers Across the Sciences**

A hands-on handbook for building publication-quality diagrams — flowcharts, study-design
schematics, step-by-step methods, and more — using [TikZiT](https://github.com/tikzit/tikzit) for
VS Code and the underlying TikZ/LaTeX it generates. The worked examples lean on epidemiology and
clinical research (STROBE, CONSORT, PRISMA flow diagrams are some of the best-specified diagram
standards out there, which makes them good teaching material), but nothing about the tooling,
workflow, or techniques is specific to that field — researchers in any lab or computational
science writing papers, theses, or grant applications should find the same patterns apply
directly to their own flowcharts, pipeline diagrams, and method schematics.

## Why this exists

The original TikZiT.app (macOS) is deprecated. The [TikZiT VS Code extension](https://marketplace.visualstudio.com/items?itemName=tikzit.tikzit-vscode)
is the actively maintained successor, but it works differently enough that existing TikZiT.app
tutorials don't map cleanly onto it. This handbook is a from-scratch, VS-Code-first guide,
written while learning the extension, aimed at researchers who need diagrams for papers and
grant applications rather than general graph-drawing.

## Reading order

Start at [book/index.md](book/index.md), which links every chapter in order. Each chapter is a
standalone Markdown file so it renders fine on GitHub.

## Repository layout

| Path | Purpose |
|---|---|
| `book/` | The handbook chapters (Markdown) |
| `styles/` | Reusable TikZ/TikZiT style files (node/edge styles) |
| `templates/` | Ready-to-adapt diagram templates (STROBE, CONSORT, PRISMA, a left-aligned lab-protocol style; cohort/HBM/risk-assessment/DAG folders are placeholders — see [Chapter 6](book/chapter06_templates.md)) |
| `examples/` | A worked example paper showing figures embedded in a LaTeX manuscript |
| `images/` | Rendered PNG/SVG exports of figures, for embedding in the book itself |
| `scripts/` | Small helper scripts (e.g. batch-compiling `.tikz` files to PDF/PNG) |

## Requirements

- [VS Code](https://code.visualstudio.com/) 1.126+
- [TikZiT extension](https://marketplace.visualstudio.com/items?itemName=tikzit.tikzit-vscode) 0.5+
- A LaTeX distribution (e.g. TeX Live or MacTeX) with the `tikz` package, for compiling figures
  into PDFs for papers
- (Optional) `pdftoppm`/`pdf2svg`/ImageMagick for exporting PNG/SVG previews

## License

Code and templates are released under the [MIT License](LICENSE). See [CITATION.cff](CITATION.cff)
for how to cite this handbook.
