#!/bin/sh

git checkout source && make build && git checkout master && mv dist/* . && git add -A && git commit -m \"Update\" && git push origin master
