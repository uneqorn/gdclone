#!/bin/sh

cd editor
love-release -W32
mv releases/.love ../editor.love
mv releases/love-0.9.2-win32/.exe ../editor.exe
rm -r releases
cd ..

cd game
love-release -W32
mv releases/.love ../game.love
mv releases/love-0.9.2-win32/.exe ../game.exe
rm -r releases
cd ..
