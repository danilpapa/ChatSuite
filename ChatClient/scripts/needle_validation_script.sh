#! /bin/bash

export SOURCEKIT_LOGGING=0

if ! command -v needle &> /dev/null; then
    brew install needle
fi

echo "Generating Needle dependencies for HeedAssembly..."

needle generate \
  "Core/HeedAssembly/HeedAssembly/Sources/Generated/NeedleGenerated.swift" \
  "Core/HeedAssembly/HeedAssembly/Sources" \
  --header-doc "''"