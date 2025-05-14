shader_type canvas_item;

uniform vec4 dark_color = vec4(1.0, 0.0, 0.0, 1.0);     // rojo fuerte
uniform vec4 light_color = vec4(1.0, 0.7, 0.7, 1.0);    // rojo claro o rosado

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float brightness = tex_color.r; // En imagen B/N, cualquier canal sirve
    vec4 final_color = mix(dark_color, light_color, brightness);
    COLOR = vec4(final_color.rgb, tex_color.a);
}
