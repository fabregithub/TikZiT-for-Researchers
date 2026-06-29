#!/usr/bin/env bash
# Batch-compile every .tikz file under templates/ and examples/figures/ to
# PDF, PNG, and SVG, without depending on the VS Code extension (or its
# dvisvgm-based SVG export, which is broken on some TeX Live installs --
# see book/chapter09_troubleshooting.md). Requires: pdflatex, pdftocairo,
# pdftoppm (the latter two ship with poppler).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT/cache/build-all"
OUT_DIR="$ROOT/images"

mkdir -p "$BUILD_DIR" "$OUT_DIR"

build_one() {
    local tikz_file="$1"
    local name
    name="$(basename "$tikz_file" .tikz)"
    local wrapper="$BUILD_DIR/$name.tex"

    {
        echo '\documentclass{article}'
        echo '\usepackage{tikzit}'
        echo '\tikzstyle{every picture}=[tikzfig]'
        echo '\usepackage[graphics,active,tightpage]{preview}'
        echo '\PreviewEnvironment{tikzpicture}'
        echo "\\input{$ROOT/epiflow.tikzstyles}"
        echo "\\input{$ROOT/epiflow.tikzdefs}"
        echo '\begin{document}'
        echo
        cat "$tikz_file"
        echo
        echo '\end{document}'
    } > "$wrapper"

    cp "$ROOT/tikzit.sty" "$BUILD_DIR/"

    echo "Building $name..."
    if ! pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$BUILD_DIR" "$wrapper" > "$BUILD_DIR/$name.buildlog" 2>&1; then
        echo "  FAILED — see $BUILD_DIR/$name.buildlog"
        return 1
    fi

    cp "$BUILD_DIR/$name.pdf" "$OUT_DIR/$name.pdf"
    pdftocairo -svg "$BUILD_DIR/$name.pdf" "$OUT_DIR/$name.svg"
    pdftoppm -png -r 150 -singlefile "$BUILD_DIR/$name.pdf" "$OUT_DIR/$name"
    echo "  OK -> images/$name.{pdf,svg,png}"
}

shopt -s nullglob
for tikz_file in "$ROOT"/templates/*/*.tikz "$ROOT"/examples/figures/*.tikz; do
    build_one "$tikz_file" || true
done
