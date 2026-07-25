shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 0.25;
uniform float speed = 12.0;

float hash(float n) {
	return fract(sin(n) * 43758.5453123);
}

void fragment() {
	float row = floor(UV.y * 96.0);
	float jitter = (hash(row + floor(TIME * speed)) - 0.5) * intensity * 0.035;
	vec2 uv_r = UV + vec2(jitter, 0.0);
	vec2 uv_b = UV - vec2(jitter, 0.0);
	vec4 r = texture(TEXTURE, uv_r);
	vec4 g = texture(TEXTURE, UV);
	vec4 b = texture(TEXTURE, uv_b);
	COLOR = vec4(r.r, g.g, b.b, g.a);
}
