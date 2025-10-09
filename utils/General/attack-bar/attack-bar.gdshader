shader_type canvas_item;
uniform float fill_amount : hint_range(0.0, 1.0);

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // centro en (0,0)
    float radius = length(uv);

    float angle = atan(uv.y, uv.x);
    angle = (angle + 3.14159265) / (2.0 * 3.14159265);

    if (radius <= 1.0 && angle <= fill_amount) {
		vec4 text= texture(TEXTURE,UV);
        COLOR = text;
    } else {
        discard;
    }
}
