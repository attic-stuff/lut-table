attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 vv_tex;
varying vec4 vv_col;

void main()	{
	vec4 position = vec4(in_Position.xyz, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * position;
	vv_tex = in_TextureCoord;
	vv_col = in_Colour;
}