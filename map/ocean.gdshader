shader_type spatial;


uniform sampler2D uv_offset_texture;
uniform vec2 uv_offset_scale = vec2(0.1, 0.1);
uniform vec2 time_scale = vec2(0.02, 0.0);

uniform vec4 color : source_color;

void vertex() {
	vec2 base_uv_offset = UV * uv_offset_scale;
	base_uv_offset += TIME * time_scale;
	
	float noise = texture(uv_offset_texture, base_uv_offset).r;
	
	VERTEX.z += noise;
}

void fragment() {
	ALBEDO = color.rgb;
}
