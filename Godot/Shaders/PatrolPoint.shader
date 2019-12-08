shader_type spatial;
render_mode unshaded;

void fragment() {
	float time_cos = cos(TIME*2.0)/8.0;
	ALBEDO = vec3(0.0, 0.8 + time_cos, 0.2 + time_cos);
}