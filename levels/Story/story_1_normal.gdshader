shader_type canvas_item;

// Tonos personalizables
uniform vec4 dark_color = vec4(0.4, 0.3, 0.0, 1.0);   // Amarillo oscuro (para el negro original)
uniform vec4 light_color = vec4(1.0, 0.9, 0.4, 1.0);  // Amarillo claro (para el blanco original)

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float brightness = tex_color.r; // en B/N, r == g == b
    vec4 color_mapped = mix(dark_color, light_color, brightness);
    COLOR = vec4(color_mapped.rgb, tex_color.a);
}
