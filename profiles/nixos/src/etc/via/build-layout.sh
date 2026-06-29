#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define file names
INPUT_FILE="linky87.layout.najib03.jsonc"
OUTPUT_FILE="linky87.layout.najib03.json"

# Check if the source .jsonc file actually exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Source file '$INPUT_FILE' not found in this directory!"
    exit 1
fi

echo "Stripping comments from $INPUT_FILE..."

# Run inside a pure nix-shell with nodejs and the CLI tool pre-installed
nix-shell -p nodejs nodePackages.strip-json-comments-cli --run \
    "strip-json-comments $INPUT_FILE > $OUTPUT_FILE"

echo "Success! Clean layout file generated: $OUTPUT_FILE"
