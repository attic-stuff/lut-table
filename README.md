# lut table

### color grading with a look up table table for all the cutie gamemakers out there

![spincube](C:\Users\cecil\Desktop\work\GM REPOs\lut-table\spincube.gif)

imagine that every color in your game is hiding in this pretty color cube. its got all your colors but one day you wake up and go "dang i wish i had different colors in my game" or "hot dang i need to make it night time in my game but i dont wanna make a separate tileset :(." well you are in luck because this is a common riddle to solve in games and there are several solutions—we're going to skip past every single one and stop at using a color lookup table. if we sliced that cube up and looked at its parts, it looks like this:

![neutral16x](C:\Users\cecil\Desktop\work\GM REPOs\lut-table\neutral16x.png)

a neutral lookup table. if we took this table and told a shader to make your game use these colors, your game would not change. but what if we told it to use this one?

![16xgraded](C:\Users\cecil\Desktop\work\GM REPOs\lut-table\16xgraded.png)

now your game will be like, way cooler looking. what if we were like "hey shaders make my game go from morning to night" then we could use several color lookup tables and make the game look like this:

![timelapse](C:\Users\cecil\Desktop\work\GM REPOs\lut-table\timelapse.gif)

we choose different tables based on the time of day, and color grade the game by interpolating between those tables. pretty neat huh? i got the idea from graveyard keeper. well there is a shader in this repo you can use to get this cool effect.

### how do i do this?

the way it works is as a post processing effect; as in you grade a whole frame rather than a single sprite or texture. you send the shader a texture of look up tables, tell it which two you want to use, how much you would like to mix those two corrections and then how much you would like to mix that color grading into the frame. lets look at the uniforms first and then some examples on how to use it.

| sampler2d table                                              |
| ------------------------------------------------------------ |
| this is the lookup table table. it must be on its own texture page, and it must be a power of two sized texture. that means if you have seven tables, your texture must be sized 512x512. this seems bad, to have a lot of blank space. its fine. |

| vec2 parameters                                              |
| ------------------------------------------------------------ |
| parameters.x is the **resolution** of your look up table. we've been looking at luts with are resolution of 16, meaning each slice of our cube is 16x16 pixels. this shader supports luts with resolutions of 16, 32, and 64 |
| parameters.y is the **number of tables** on the table.  this is not the number of present luts it is the number of possible luts. it should always be your (power of two) lut table height divided by the resolution. |

| vec4 instructions                                            |
| ------------------------------------------------------------ |
| instructions.x is table **A** to use for the color grading.  |
| instructions.y is table **B** to use for the color grading.  |
| instructions.z is the **table mix** between A and B.         |
| instructions.w is the **frame mix**; which is how much we mix the final table mix with the scene |

### examples

##### example 1: combining two lookup tables for a day/night cycle

in the project file you will find a pre made lut table, and on it there is 9 luts. these are zero-index (first one is 0 not 1) 0 through 8 right? well if we use lut 3 and lut 8 we can make a pretty cool day to night timer.
```js
/* C R E A T E EVENT */
application_surface_draw_enable(false);

//lets call our time minute and day. 18000 frames is about five minutes
//and are gunna count minutes until minutes is equal to day
day = 18000;
minute = 0;

//lets setup some uniforms
uniforms = array_create(3);
uniforms[0] = shader_get_sampler_index(pp_luttable, "table");
uniforms[1] = shader_get_uniform(pp_luttable, "parameters");
uniforms[2] = shader_get_uniform(pp_luttable, "instructions");
//x16 is the name of our lut table
texture = sprite_get_texture(x16, 0);
//it uses 16x16 slices of color
resolution = 16;
//this has to be the to
tables = sprite_get_height(x16) / resolution;

//set up our instructions
A = 3;
B = 8;
//initially table A should be the only color grading present
//and we will change this over time to make it night
tablemix = 0.0;
framemix = 1.0;

/* S T E P EVENT */
//count minutes
if (minute < day) {
    minute += 1;
}
//figure out how much of the day has passed
var p = minute / day;
//this percentage is how much we mix table B into table A
//so when 0 minutes has passed we will be fully table A, when minutes is
//9000 then we will be 50% A and 50% B, etc etc
tablemix = p;

/* P O S T  D R A W EVENT */
shader_set(pp_luttable) {
	texture_set_stage(u[0], texture);
	shader_set_uniform_f(u[1], resolution, tables);
	shader_set_uniform_f(u[2], A, B, tablemix, framemix);
	gpu_set_tex_filter_ext(u[0], true);
	draw_surface(application_surface, 0, 0);
	gpu_set_tex_filter_ext(u[0], false);
	shader_reset();
}
```

##### example 2, using a single lut to color grade a surface

maybe you want to draw a bunch of cool stuff to a surface and give it a %50 color grade using just a single table

```js
/* C R E A T E EVENT */
application_surface_draw_enable(false);

//lets setup some uniforms
uniforms = array_create(3);
uniforms[0] = shader_get_sampler_index(pp_luttable, "table");
uniforms[1] = shader_get_uniform(pp_luttable, "parameters");
uniforms[2] = shader_get_uniform(pp_luttable, "instructions");
//x16 is the name of our lut table
texture = sprite_get_texture(x16, 0);
//it uses 16x16 slices of color
resolution = 16;
//this has to be the to
tables = sprite_get_height(x16) / resolution;

//set up our instructions
A = 2;
B = 2;
//set A and B to the same index, then set the frame mix to 50%.
tablemix = 1.0;
framemix = 0.5;

/* P O S T  D R A W EVENT */
shader_set(pp_luttable) {
	texture_set_stage(u[0], texture);
	shader_set_uniform_f(u[1], resolution, tables);
	shader_set_uniform_f(u[2], A, B, tablemix, framemix);
	gpu_set_tex_filter_ext(u[0], true);
	draw_surface(application_surface, 0, 0);
	gpu_set_tex_filter_ext(u[0], false);
	shader_reset();
}
```

