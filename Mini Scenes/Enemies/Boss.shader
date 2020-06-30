shader_type canvas_item;

uniform float health;
uniform float max_health;

void fragment() {
    vec4 curr_color = texture(TEXTURE,UV); // Get current color of pixel
	
	vec4 red = vec4(1, 0, 0, 1);
	vec4 blue = vec4(0, 56.0/255.0, 96.0/255.0, 1);
	vec4 violet = vec4(105.0/255.0, 55.0/255.0, 128.0/255.0, 1);

	if (curr_color != red && curr_color != blue && curr_color != violet && curr_color.a > 0.1) {
        COLOR = vec4(curr_color.r, curr_color.g, curr_color.b, max(health/max_health, 0.1));
    } else {
		COLOR = curr_color;
	}
}