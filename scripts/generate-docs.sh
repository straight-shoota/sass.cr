#! /bin/sh
GENERATED_DOCS_DIR="./doc"

echo "Building docs into ${GENERATED_DOCS_DIR}"
echo "Clearing ${GENERATED_DOCS_DIR} directory"
rm -rf "${GENERATED_DOCS_DIR}"

echo "Running crystal doc..."
crystal doc

echo "Copying README.md"
cp README.md "${GENERATED_DOCS_DIR}/README.md"
