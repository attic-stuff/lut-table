varying vec2 vv_tex;
varying vec4 vv_col;

uniform sampler2D table;
uniform vec2 parameters;
uniform vec4 instructions;

void main() {
	vec4 pixel = texture2D(gm_BaseTexture, vv_tex);
	
	vec2 colors = vec2(parameters.x - 1.0, (parameters.x - 1.0) / parameters.x);
	vec2 dimensions = vec2(parameters.x * parameters.x, parameters.x * parameters.y);
	vec2 offset = 0.5 / dimensions;
	
	float blue = pixel.b * colors.x;
	float red = offset.x + pixel.r / parameters.x * colors.y;
	float green = offset.y + pixel.g * colors.y / parameters.y;
	
	vec2 left; vec2 right; float index;
	
	index = instructions.x / parameters.y;
	left = vec2(floor(blue) / parameters.x + red, green + index);
	right = vec2(ceil(blue) / parameters.x + red, green + index);
	vec3 A = mix(texture2D(table, left).rgb, texture2D(table, right).rgb, fract(blue));
	
	index = instructions.y / parameters.y;
	left.y = green + index;
	right.y = green + index;
	vec3 B = mix(texture2D(table, left).rgb, texture2D(table, right).rgb, fract(blue));
	
	pixel.rgb = mix(pixel.rgb, mix(A, B, instructions.z), instructions.w);

	gl_FragColor = vv_col * pixel;
}