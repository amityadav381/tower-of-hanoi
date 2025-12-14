shader_type canvas_item;

uniform float stripe_width : hint_range(0.01, 0.5) = 0.1;
uniform float angle = 0.785398;

/* Speed of stripe movement */
uniform float speed = 0.2;

/* Internal time accumulator */
uniform float time = 0.0;

uniform vec4 color_a : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_b : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec2 uv = UV - 0.5;

    float s = sin(angle);
    float c = cos(angle);

    mat2 rot = mat2(
        vec2(c, -s),
        vec2(s,  c)
    );

    // Rotate UVs
    uv = rot * uv;

    // Move stripes along their direction
    uv.x += time * speed;

    float stripes = step(0.5, fract(uv.x / stripe_width));
    COLOR = mix(color_a, color_b, stripes);
}
