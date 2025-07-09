shader_type canvas_item;

void fragment(){
	 vec2 distortedUV = UV;
	distortedUV.y += sin(distortedUV.x * 1.5 + TIME * 1.0) * 0.05;
	COLOR = texture(TEXTURE, distortedUV);
}