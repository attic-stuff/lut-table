<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/spincube.gif"/></p>

# lut table

#### color grading shader for gamemaker that uses a table of lookup tables. its a lookup table table.

color grading is a pretty important aspect of your game's tech art pipeline. if you've ever tried a day/night cycle with blendmodes or drawing rectangles over the screen you know it can get ugly or slow fast. this is true of doing other kinds of grading too; you can make your game greyscale with a single line of glsl but you dont get the benefit of dramatic contrast and brightness adjustments thattaway. color grading with luts are just a very visual and easy way to get that game lookin so good. *lut table* (loot table) is a shader that solves that problem—it samples a whole table full of color luts and allows you to interpolate between two of them like some kind of color correcting galactic hero. the idea comes from how i believe [graveyard keeper](https://www.gamedeveloper.com/programming/graveyard-keeper-how-the-graphics-effects-are-made) uses color luts for its day night cycle, and you can [click here](https://i.imgur.com/QSgGEdX.mp4) to see a very rubbish quality video of how i use it in my own game's day/night cycle.

#### whats a ding dong color lut?

lut stands for lookup table. like when you need to look up some information in a book or on a calendar, you can do the same thing using colors in your game. matter of fact, imagine every color in your game is hiding somewhere in that spinnin' cube of pretty colors up there. you can go "alright my blue is in this corner, so what if i use a different cube and in that corner i will put yellow." we don't use cubes for this though because thats black magic; what we do instead of slice that cube up into our lut:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/neutral16x.png"/></p>

that's a neutral lut though; its all the colors in our game already. if we graded our frame with this it would look normal. but what if we graded it with this one:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/16xsepia.png"/></p>

then our game would be sepia toned. but not just mathematically sepia'ed up: i hand made this lookup table to have more contrast and be a little pretty than just manually mixing brown into the frame with math!

| sampler2d table                                              |
| :----------------------------------------------------------- |
| this is the lookup table table. it must be on its own texture page, and it must be a power of two sized texture. that means if you have seven tables, your texture must be sized 512x512. this seems bad, to have a lot of blank space. its fine. |

| vec2 parameters                                              |
| :----------------------------------------------------------- |
| parameters.x is the **resolution** of your look up table. we've been looking at luts with are resolution of 16, meaning each slice of our cube is 16x16 pixels. this shader supports luts with resolutions of 16, 32, and 64 |
| parameters.y is the **number of tables** on the table.  this is not the number of present luts it is the number of possible luts. it should always be your (power of two) lut table height divided by the resolution. |

| vec4 instructions                                            |
| :----------------------------------------------------------- |
| instructions.x is table **A** to use for the color grading.  |
| instructions.y is table **B** to use for the color grading.  |
| instructions.z is the **table mix** between A and B.         |
| instructions.w is the **frame mix**; which is how much we mix the final table mix with the scene |
