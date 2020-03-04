#!/bin/sh

git checkout source
make build
git checkout master
cp -R dist/* .
rm -r dist
git add -A
git commit -m \"Update\"
git push
echo "finished!"
