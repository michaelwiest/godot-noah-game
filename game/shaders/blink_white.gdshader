shader_type canvas_item;

uniform bool show = true;

void fragment(){
	float opacity_int = float(int(show));
	vec3 color = texture(TEXTURE, UV).rgb;
	
	float color_r = color.r;
	float color_g = color.g;
	float color_b = color.b;
	COLOR = vec4(color_r, color_g, color_b, opacity_int *  texture(TEXTURE, UV).a);
}