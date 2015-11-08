# gdclone
This is a clone of the game "Geometry Dash" made in love2d.

So, this is divided in two different programs; the game and the level editor.

#game
You can load and play any level which is in the folder "levels". Later I'll explain how levels are saved and loaded.

Press/hold space or left click to jump.

Press f to show fps.

Press escape to exit.
![](https://i.imgur.com/kjj07d1.png)
![](https://i.imgur.com/Mei8JYZ.png)

#editor
Lets you load any level inside the "levels" folder and edit it, currently the only objects available are blocks and spikes.

Left click to place selected object.

Right click to destroy object.

Scroll up/down to change object.

Press s to save level.

Press escape to exit.
![](https://i.imgur.com/PI43TxP.png)
![](https://i.imgur.com/AzzSm5Q.png)

#Levels
Levels are pretty straightforward. Each 'level' is just a folder with two files; 'blocks.txt' and 'spikes.txt'.
In these files each line is a block/spike which is divided in two numbers separated by spaces; the first number is the x coordinate and the second is the y coordinate.
'readlevel.lua' reads that and returns a table, which then is used by the 'createBlocks' and 'createSpikes' functions to create objects.
