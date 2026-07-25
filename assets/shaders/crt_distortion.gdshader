shader_type canvas_item;

uniform float scanline_strength : hint_range(0.0, 1.0) = 0.18;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.35;
uniform float warp_strength : hint_range(0.0, 0.08) = 0.015;

void fragment() {
	vec2 uv = UV;
	vec2 centered = uv * 2.0 - 1.0;
	uv += centered * dot(centered, centered) * warp_strength;
	vec4 color = texture(TEXTURE, uv);
	float scanline = sin(uv.y * 720.0) * 0.5 + 0.5;
	color.rgb *= 1.0 - scanline * scanline_strength;
	float vignette = smoothstep(1.05, 0.25, length(centered));
	color.rgb *= mix(1.0 - vignette_strength, 1.0, vignette);
	COLOR = color;
}
