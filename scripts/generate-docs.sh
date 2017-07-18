#! /bin/sh
GENERATED_DOCS_DIR="./doc"

echo -e "Building docs into ${GENERATED_DOCS_DIR}"
echo -e "Clearing ${GENERATED_DOCS_DIR} directory"
rm -rf "${GENERATED_DOCS_DIR}"

echo -e "Running crystal doc..."
crystal doc

echo -e "Copying README.md"
cp README.md "${GENERATED_DOCS_DIR}/README.md"
