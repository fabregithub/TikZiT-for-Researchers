#!/usr/bin/env bash
# Concatenate every book/*.md chapter (in reading order) into a single PDF
# via pandoc. Strips the "[← Index] | ... | [Next: ...]" nav lines first
# (meaningless in a single combined PDF), and gives every top-level chapter
# heading a page break so chapters start cleanly.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BOOK_DIR="$ROOT/book"
BUILD_DIR="$ROOT/cache/build-book"
OUT="$ROOT/TikZiT-for-Researchers.pdf"

mkdir -p "$BUILD_DIR"

CHAPTERS=(
    preface.md
    chapter01_introduction.md
    chapter02_installation.md
    chapter03_first_steps.md
    chapter04_styles.md
    chapter05_flowcharts.md
    chapter06_templates.md
    chapter07_cookbook.md
    chapter08_advanced_tikz.md
    chapter09_troubleshooting.md
    appendix.md
)

COMBINED="$BUILD_DIR/combined.md"
> "$COMBINED"

for chapter in "${CHAPTERS[@]}"; do
    # Drop nav lines (lines made up only of "[...]" links separated by "|"),
    # then force a page break before each chapter's first heading.
    grep -vE '^\[(←|Next)' "$BOOK_DIR/$chapter" | sed '1s/^# /\\newpage\n\n# /' >> "$COMBINED"
    echo >> "$COMBINED"
done

pandoc "$COMBINED" \
    --pdf-engine=xelatex \
    --toc --toc-depth=2 \
    --number-sections \
    -V geometry:margin=1in \
    -V title="TikZiT for Researchers" \
    -V subtitle="Scientific Diagrams and Flowcharts with TikZiT and TikZ: A Practical Guide for Researchers Across the Sciences" \
    -V author="" \
    -V date="$(date +%Y-%m-%d)" \
    --resource-path="$BOOK_DIR:$ROOT" \
    -o "$OUT"

echo "Built $OUT"
