var u = uniforms;

if (sidebyeside == false) {
	shader_set(pp_luttable) {
		texture_set_stage(u[0], texture);
		shader_set_uniform_f(u[1], resolution, tables);
		shader_set_uniform_f(u[2], A, B, tablemix, framemix);
		gpu_set_tex_filter_ext(u[0], true);
		draw_surface(application_surface, 0, 0);
		gpu_set_tex_filter_ext(u[0], false);
		shader_reset();
	}
} else {

	shader_set(pp_luttable) {
		texture_set_stage(u[0], texture);
		shader_set_uniform_f(u[1], resolution, tables);
		shader_set_uniform_f(u[2], A, B, 0, 1);
		gpu_set_tex_filter_ext(u[0], true);
		draw_surface_part(application_surface, 0, 0, 320, 360, 0, 0);
		gpu_set_tex_filter_ext(u[0], false);
		shader_reset();
	}
	
	shader_set(pp_luttable) {
		texture_set_stage(u[0], texture);
		shader_set_uniform_f(u[1], resolution, tables);
		shader_set_uniform_f(u[2], A, B, 1, 1);
		gpu_set_tex_filter_ext(u[0], true);
		draw_surface_part(application_surface, 320, 0, 320, 360, 320, 0);
		gpu_set_tex_filter_ext(u[0], false);
		shader_reset();
	}
	
}


var text = "table [a]: " + string(A) + "\ntable [b]: " + string(B) + "\n[t]able mix: " + string(tablemix) + "\n[f]rame mix: " + string(framemix);
draw_text_ext_color(2, -3, text, 9, 128, #080808, #080808, #080808, #080808, 1);
draw_text_ext_color(2, -4, text, 9, 128, #dbd2b8, #dbd2b8, #dbd2b8, #dbd2b8, 1);

