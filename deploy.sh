#!/bin/sh

make build && \
git checkout master && \
cp -r dist/* . && \
rm -r dist && \
git add -A && \
git commit -m "Update" && \
echo "finished!"
