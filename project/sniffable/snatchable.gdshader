shader_type spatial;

uniform float speed = 1.0;
uniform sampler2D noise;

void fragment(){
	ALBEDO = vec3(.02, cos(sin(TIME*speed)), .1);
}

void vertex() {
	// Called every frame on existing particles (according to the Fixed FPS property).

	// This is a good grass
	float height = texture(noise, VERTEX.xz).r;
	VERTEX += NORMAL * height * (sin(cos(TIME))*.5-.3);
	
	//VERTEX.y += cos(VERTEX.x * 4.0) * sin(VERTEX.z * 4.0);
}
