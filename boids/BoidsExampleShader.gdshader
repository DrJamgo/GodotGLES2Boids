shader_type canvas_item;

uniform sampler2D state_texture;
uniform vec2 world_size;

varying vec2 velocity;

vec2 rgba_to_world(in vec4 color)
{
    vec2 vector;
    vector = color.rb + color.ga / 255.0;
    vector *= world_size;
    return vector;
}

vec2 rotate(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(vec2(c, s), vec2(-s, c));
	return m * v;
}

void vertex() {
    velocity = texture(state_texture, INSTANCE_CUSTOM.xy - vec2(0,0.5)).rg;
    float angle = atan(velocity.g-0.5, velocity.r-0.5);
    
    VERTEX.xy = rotate(VERTEX.xy, angle);
    
    // translate according to particle data
    VERTEX += rgba_to_world(texture(state_texture, INSTANCE_CUSTOM.xy));
}

void fragment(){
    COLOR = texture(TEXTURE, UV);
    COLOR.rg = velocity;
}