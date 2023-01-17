# lut table

### lookup table color grading for all the cute gamemakers out there

![spincube](https://github.com/attic-stuff/lut-table/blob/main/spincube.gif)

imagine every possible color in your game is stashed in this cool spinning cube of pretty candy colors. but then you're like "well heck i wish my game actually had different colors" but you were also like "aw crap i donut have time to recolor my whole ass game." the solution to that problem is color grading and palette swapping. for small things, palette swapping is pretty great and useful, you just say "okay game replace all black pixels with green pixels" and be done with it. for more complex color grading you need to use either a bunch of math (yuck!) or a lookup table. want to make your game look like its from the 70s? maybe greyscale but with cool contrast? what about just doing a regular-ass, good ol' fashioned day-to-night cycle like i do in this gamemaker project i been working on. i got the idea from [graveyard keeper](www.gamedeveloper.com/programming/graveyard-keeper-how-the-graphics-effects-are-made), btw and it looks like this:

[![timelapse](https://github.com/attic-stuff/lut-table/blob/main/timelapse.gif)](https://i.imgur.com/QSgGEdX.mp4)

you can click this low quality gif to see a bigger low quality gif. at any rate, this repo has a shader that allows you to do this pretty easy. its called **pp_luttable** (pronounced loot table, like as in video game reward feedback loop things) and it allows you to color grade your game with a lookup table of color lookup tables. its a lookup table table. since we cannot really use a spinning cube of colors to change the color of our game we have to slice that guy up into something that looks like this neutral look up table:

![neutral16x](https://github.com/attic-stuff/lut-table/blob/main/neutral16x.png)

its called neutral because if you used it to color correct your game, your game would look exactly the same! and also there's just one there. what we want is a whole table of tables! more like this:

![16xtable](https://github.com/attic-stuff/lut-table/blob/main/16xtable.png)

look at this sucker we got neutral, cool stuff, grey scale, sepia, inverted, and even some darker stuff. with plenty of room to add more! dang we're about to be in color grading dog heaven. not only do we have more options on a table of tables, its more performant to quickly swap through them from a single texture _and_ we can easily index which tables we want to interpolate thru. 

