shader_type canvas_item;
uniform bool toggle;

void fragment() {
	vec4 output;
	if (toggle){
		float intensity = (COLOR.x + COLOR.y + COLOR.z) / 3.0 * 1.7; 
		output = vec4(intensity, intensity, intensity, COLOR.a) * vec4(1.0, 0.84, 0.0, 1.0);
	}
	else {
		output = COLOR;
	}
	COLOR = output;
		
		
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
