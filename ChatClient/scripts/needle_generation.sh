#!/bin/bash

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCES_DIR="$PROJECT_ROOT/Core/HeedAssembly/HeedAssembly/Sources"
GENERATED_DIR="$SOURCES_DIR/Generated"
OUTPUT_FILE="$GENERATED_DIR/NeedleGenerated.swift"

echo "🔧 Generating Needle DI code..."
echo "Project Root: $PROJECT_ROOT"
echo "Sources Dir: $SOURCES_DIR"
echo "Output File: $OUTPUT_FILE"

mkdir -p "$GENERATED_DIR"
needle generate "$OUTPUT_FILE" "$SOURCES_DIR" --header-doc "$SOURCES_DIR/header_doc.txt"

if [ $? -eq 0 ]; then
    echo "✅ Needle DI code generated successfully at: $OUTPUT_FILE"
else
    echo "❌ Failed to generate Needle DI code"
    exit 1
fi
