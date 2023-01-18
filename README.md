<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/spincube.gif"/></p>

# lut table

### color grading shader for gamemaker that uses a table of lookup tables. its a lookup table table.

color grading is a pretty important aspect of your game's tech art pipeline. if you've ever tried a day/night cycle with blendmodes or drawing rectangles over the screen you know it can get ugly or slow fast. this is true of doing other kinds of grading too; you can make your game greyscale with a single line of glsl but you dont get the benefit of dramatic contrast and brightness adjustments thattaway. color grading with luts are just a very visual and easy way to get that game lookin so good. *lut table* (loot table) is a shader that solves that problem—it samples a whole table full of color luts and allows you to interpolate between two of them like some kind of color correcting galactic hero. the idea comes from how i believe [graveyard keeper](https://www.gamedeveloper.com/programming/graveyard-keeper-how-the-graphics-effects-are-made) uses color luts for its day night cycle, and you can [click here](https://i.imgur.com/QSgGEdX.mp4) to see a very rubbish quality video of how i use it in my own game's day/night cycle.

### whats a ding dong color lut?

lut stands for lookup table. like when you need to look up some information in a book or on a calendar, you can do the same thing using colors in your game. matter of fact, imagine every color in your game is hiding somewhere in that spinnin' cube of pretty colors up there. you can go "alright my blue is in this corner, so what if i use a different cube and in that corner i will put yellow." we don't use cubes for this though because thats black magic; what we do instead of slice that cube up into our lut:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/lut%20textures/neutral16x.png"/></p>

that's a neutral lut though; its all the colors in our game already. if we graded our frame with this it would look normal. but what if we graded it with this one:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/lut%20textures/16xsepia.png"/></p>

then our game would be sepia toned. but not just mathematically sepia'ed up: i hand made this lookup table to have more contrast and be a little prettier than just manually mixing brown into the frame with math!

### how 2 use this sucker

there is an example project in a yyz that you can play with to learn how to use the pp_luttable shader. it takes a table of luts as a texture, as well as a vec2 of parameters for that texture:

| sampler2d table                                              |
| :----------------------------------------------------------- |
| this is the lookup table table. it must be on its own texture page, and it must be a power of two sized texture. if your lut resolution is 16x then your width is 16x16 (256 for the homies) which means your texture has to be 16x 32, 64, 128, 256, 512, etc etc. even if you do not use the whole texture, it has to be power of two. thanks. |

| vec2 parameters                                              |
| :----------------------------------------------------------- |
| parameters.x is the **resolution** of your look up table. we've been looking at luts with a resolution of 16x, meaning each slice of our cube is 16x16 pixels. this shader supports luts with resolutions of 16, 32, and 64 though. remember to follow the power of two rules for textures though. if you use a 32x resolution table then your texture size must have a width of 1024 (which is 32x32) and a height of 32, 64, 128, etc. |
| parameters.y is the **number of tables** on the table.  this is not the number of present luts it is the number of possible luts. it should always be your (power of two) lut table height divided by the resolution. |

it also must be given instructions. this shader is intended to be used for grading luts into one another and then grading that final color into your frame. to accomplish that you need table A, table B, how much to mix those two luts and then how much to mix that into the frame. with these:

| vec4 instructions                                            |
| :----------------------------------------------------------- |
| instructions.x is table **A** to use for the color grading. luts are zero-indexed on the texture, so if A is 0 it means "use the first lut" |
| instructions.y is table **B** to use for the color grading.  |
| instructions.z is the **table mix** between A and B. if this is 0.5, then we mix 50% of B into A. |
| instructions.w is the **frame mix**; which is how much we mix the final table mix with the scene. if this is .75, then we are mixing 75% of the table mix into the frame. |

you can however, use this shader to just do a single mix and uncomplex things. by setting A to the lut index you want to use, B to 0, table mix to 0, and frame mix to 1, you will just do regular color grading!
