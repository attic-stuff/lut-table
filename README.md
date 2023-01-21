<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/spincube.gif"/></p>

# lut table

### color grading shader for gamemaker that uses a table of lookup tables. its a lookup table table.

color grading is a pretty important aspect of your game's tech art pipeline. if you've ever tried a day/night cycle with blendmodes or drawing rectangles over the screen you know it can get ugly or slow, and is much harder to make very pretty. this is true of doing other kinds of grading too; you can make your game greyscale with a single line of glsl but you dont get the benefit of dramatic contrast and brightness adjustments thattaway. color grading with luts are just a very visual and easy way to get that game lookin so good. *lut table* (loot table) is a shader that solves that problem—it samples a whole table full of color luts and allows you to interpolate between two of them like some kind of color correcting intergalactic hero. the idea comes from how i believe [graveyard keeper](https://www.gamedeveloper.com/programming/graveyard-keeper-how-the-graphics-effects-are-made) uses color luts for its day night cycle, and you can [click here](https://i.imgur.com/QSgGEdX.mp4) to see a very rubbish quality video of how i use it in my own game's day/night cycle.

### whats a ding dang color lut?

lut stands for lookup table. like when you need to look up some information in a book or on a calendar, you can do the same thing using colors in your game. matter of fact, imagine every color in your game is hiding somewhere in that spinnin' cube of pretty colors up there. you can go "alright my blue is in this corner, so what if i use a different cube and in that corner i will put yellow." we don't use cubes for this though because thats black magic; what we do instead of slice that cube up into our lut:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/lut%20textures/neutral16x.png"/></p>

that's a neutral lut though; its all the colors in our game already. if we graded our frame with this it would look normal. but what if we graded it with this one:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/lut%20textures/16xsepia.png"/></p>

then our game would be sepia toned. but not just mathematically sepia'ed up: i hand made this lookup table to have more contrast and be a little prettier than just manually mixing brown into the frame with math!

and this, this is a table of luts. this is the table of tables and the reason we have this shader to begin with:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/lut%20table/sprites/x16/2271929c-2562-4ff0-9be4-87666920492a.png"/></p>

why a table of tables? well with regard to gamemaker's current rendering api limitations, you can only have so many samplers per shader set and using many separate textures for lut stuff can cause swaps/breaks you don't really need. so using a table of table is an ease-of-use thing and a slight optimization thing.

### how 2 use this sucker

there is an example project in a yyz that you can play with to learn how to use the pp_luttable shader. it takes a table of luts as a texture, as well as a vec2 of parameters for that texture:

| sampler2d table                                              |
| :----------------------------------------------------------- |
| this is the lookup table table. it must be on its own texture page, and it must be a power of two sized texture. if your lut resolution is 16x then your width is 16x16 (256 for the homies) which means your texture has to be 16x 32, 64, 128, 256, 512, etc etc. even if you do not use the whole texture, it has to be power of two. thanks. |

| vec2 parameters                                              |
| :----------------------------------------------------------- |
| parameters.x is the **resolution** of your look up table. we've been looking at luts with a resolution of 16x, meaning each slice of our cube is 16x16 pixels. this shader supports luts with resolutions of 16, 32, and 64 though. remember to follow the power of two rules for textures though. if you use a 32x resolution table then your texture size must have a width of 1024 (which is 32x32) and a height of 32, 64, 128, etc. |
| parameters.y is the **number of tables** on the table.  this is not the number of present luts it is the number of possible luts. it should always be your (power of two) lut table height divided by the resolution. 256 divided by 16 is 16 luts; 0 through 15. |

it also must be given instructions. this shader is intended to be used for grading luts into one another and then grading that final color into your frame. to accomplish that you need table A, table B, how much to mix those two luts and then how much to mix that into the frame. with these:

| vec4 instructions                                            |
| :----------------------------------------------------------- |
| instructions.x is table **A** to use for the color grading. luts are zero-indexed on the texture, so if A is 0 it means "use the first lut" |
| instructions.y is table **B** to use for the color grading.  |
| instructions.z is the **table mix** between A and B. if this is 0.5, then we mix 50% of B into A. |
| instructions.w is the **frame mix**; which is how much we mix the final table mix with the scene. if this is .75, then we are mixing 75% of the table mix into the frame. |

### the rules

1. your texture of multiple lookup tables must be a power of two size. that means it can be 256x16, 1024x4096, etc. one can use a single lut with this shader as well, however.
2. your lookup table table must be on a separate texture page. you can generate these dynamically with a surface though, and just pass the surface texture as the sampler using shader_get_surface.
3. you can use this shader to just do a single mix and/or uncomplex things. by setting A to the lut index you want to use, B to 0, table mix to 0, and frame mix to 1, you will just do regular color grading. neat!
4. texture filtering must be used on your lut table texture or you will get very yuck results!

### example

image we have a table of luts, and we want to interpolate A and B to do a day night transition across roughly 1 minute.

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/lut%20textures/exampletable.png"/></p>

if you have an object handling your camera or window, it would be best to do this operation that guy. the create event for whatever you use though, it should include this stuff:

```js
//disable automatic app surface drawing
application_surface_draw_enable(false);

//prepare uniforms
enum __pplut {
	texture,
	parameters,
	instructions
}
uniforms = array_create(3);
uniforms[__pplut.texture] = shader_get_sampler_index(pp_luttable, "table");
uniforms[__pplut.parameters] = shader_get_uniform(pp_luttable, "parameters");
uniforms[__pplut.instructions] = shader_get_uniform(pp_luttable, "instructions");

//prepare lut instructions, remember lut indices are zero-indexed
//start with the interpolation showing 100% of A and 0% of B
//and mix that into the whole frame
A = 1;
B = 8;
tablemix = 0.0;
framemix = 1.0;

//set up the parameters/sampler
//be sure the texture is on a separate page, and a power of 2
//our resolution is 16, our sprite height is 256 so we have 16 luts
texture = sprite_get_texture(luttable, 0));
resolution = 16;
tables = 16;

//finally setup the timing
//there are 60 frames in a second, 60 seconds in a minute, so 60 * 60 is how
//many frames in a minute
cycle = game_get_speed(gamespeed_fps) * 60;
time = 0;
```

the step event will be pretty simple, just counting frames and adjusting the mix:

```js
//increase time until the cycle is done
if (time < cycle) {
    time += 1;
}
//get the percentage of completed cycle
var p = time / cycle;
//mix lut B into lut A based on this percetange:
tablemix = p;
```

and finally the post draw event will look like this:

```js
//set the shader
shader_set(pp_luttable) {
    //stage the lut table texture and enable texture filtering on it
    texture_set_stage(uniform[__pplut.texture], texture);
    gpu_set_tex_filter_ext(uniform[__pplut.texture], true);
    //set the parameters and instructions uniforms
    shader_set_uniform_f(uniform[__pplut.parameters], resolution, table);
    shader_set_uniform_f(uniform[__pplut.instructions], A, B, tablemix, framemix);
    //draw the app surface
    draw_surface(application_surface, 0, 0);
    //then disable texture filtering on the lut table and reset to the passthru shader
    gpu_set_tex_filter_ext(uniform[__pplut.texture], false);
    shader_reset();
}
```

and thats pretty much it!

### how to make your own lut tables

if you look hard enough, you will find plenty of resources for making your own lut tables in gimp or photoshop or aseprite or whatever cool image thing you use. personally i use affinity photo. what i do is open a neutral screenshot of my game, then on another layer i put a neutral lut. like this:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/lut%20guide/a.png"/></p>

then i use the adjustments tool to color correct the scene. in this one i wanted to make a bit of a crepuscular color so i saturated it the scene a bit with the vibrance tool, pushed the white balance to be a bit warmer, then tossed a dusty purple lens filter over the whole thing. that got me this:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/lut%20guide/b.png"/></p>

when its looking real good i merge the visible layers so that all of those color corrections are applied to the neutral lut table, so i can then cut and paste the lut from that flattened image. the final result is this:

<p align="center"><img src="https://github.com/attic-stuff/lut-table/blob/main/lut%20guide/c.png"/></p>

then you can copy that to your table of tables and be done with it. the end.

### how to use the example

launch the project. hold A and scroll your mousewheel to cycle through luts for index A, hold B and scroll to cycle through luts for index B. holding T or F and scrolling the mousewheel will adjust the table and frame mixes respectively.
