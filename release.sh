#!/bin/sh

cd editor
love-release
mv releases/.love ../editor.love
rm -d releases
cd ..

cd game
love-release
mv releases/.love ../game.love
rm -d releases
cd ..
