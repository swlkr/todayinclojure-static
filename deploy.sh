#!/bin/sh

git checkout source
make build
git checkout master
cp -R dist/* .
rm -r dist
git commit -am "Update"
echo "finished!"
