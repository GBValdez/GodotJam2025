shader_type canvas_item;
uniform vec4 colorFull : source_color;
uniform float intensity: hint_range(0.0, 1.0, 0.1);

void fragment() {
 	vec4 pixel_color = texture(TEXTURE, UV);
    // Mezcla el color del píxel con el color definido
    vec3 mixColor= mix(pixel_color, colorFull, intensity).rgb;
	COLOR = vec4(mixColor,pixel_color.a);
}
