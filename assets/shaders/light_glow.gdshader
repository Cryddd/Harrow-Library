shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.78, 0.35, 1.0);
uniform float pulse_speed = 1.2;
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.18;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	float pulse = 1.0 + sin(TIME * pulse_speed) * pulse_amount;
	COLOR = vec4(mix(base.rgb, glow_color.rgb, 0.35) * pulse, base.a * glow_color.a);
}
