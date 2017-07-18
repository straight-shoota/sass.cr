#! /bin/sh
echo -e "Clearing ./doc directory"
rm -rf ./doc

echo -e "Running crystal doc..."
crystal doc

echo -e "Copying README.md"
cp README.md "doc/README.md"
