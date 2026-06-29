[← Index](index.md)

# Preface

This handbook grew out of a single, concrete problem: the maintainer of TikZiT discontinued the
standalone macOS app in favor of a VS Code extension, and the workflow changed enough that old
habits (and old tutorials) stopped applying. Rather than relearn this alone and forget it, this
project records the process as a structured handbook — partly so it's useful to other researchers
facing the same transition, and partly as a personal reference to come back to. The worked
examples happen to be drawn from epidemiology and clinical research, because STROBE/CONSORT/
PRISMA are some of the most precisely specified flowchart conventions in any field and make for
concrete, realistic teaching material — but the tools, the workflow, and the techniques in every
chapter apply just as directly to a chemistry synthesis route, a wet-lab protocol, an ecology
sampling design, or a computational pipeline diagram.

## Who this is for

- Any researcher who needs diagrams — flow diagrams, study/experimental design schematics,
  step-by-step method diagrams — for papers, theses, or grant applications. Clinical and
  epidemiological readers will recognize STROBE/CONSORT/PRISMA directly in Chapter 6; everyone
  else can use the same chapter as a template for their own field's standard diagram, if one
  exists, or as a starting point for an ad hoc one.
- Readers who are comfortable with LaTeX at a basic level but have **not** necessarily used TikZ
  or TikZiT before.
- Anyone migrating from TikZiT.app to the VS Code extension.

## How to use this book

Each chapter builds on the previous one, but chapters 6 ("Templates") and 7 ("Cookbook") are
designed to be read out of order once you've finished chapter 5 — jump straight to whichever
diagram type you need (PRISMA, CONSORT, etc.) and copy the template.

All `.tikz` source files referenced in the text live under [`templates/`](../templates/) or
[`examples/`](../examples/) in this repository, so you can open them directly in VS Code instead
of retyping from the page.

[Continue to Chapter 1: Introduction →](chapter01_introduction.md)
