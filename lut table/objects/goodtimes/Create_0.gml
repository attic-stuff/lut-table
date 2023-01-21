window_set_size(1280, 720);
surface_resize(application_surface, 640, 360);
display_set_gui_size(640, 360);
application_surface_draw_enable(false);

A = 0;
B = 0;
tablemix = 1.0;
framemix = 0.0;

draw_set_font(font);

sidebyeside = false;

uniforms = array_create(3);
uniforms[0] = shader_get_sampler_index(pp_luttable, "table");
uniforms[1] = shader_get_uniform(pp_luttable, "parameters");
uniforms[2] = shader_get_uniform(pp_luttable, "instructions");
texture = sprite_get_texture(x16, 0);
resolution = 16;
tables = 16;