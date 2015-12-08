#!/bin/sh

echo --EDITOR--
cd editor
love-release -W32
mv releases/.love ../bin/editor.love
mv releases/love-0.9.2-win32/.exe ../bin/editor.exe
rm -r releases
cd ..

echo --GAME--
cd game
love-release -W32
mv releases/.love ../bin/game.love
mv releases/love-0.9.2-win32/.exe ../bin/game.exe
rm -r releases
cd ..

