shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D state_texture;
uniform vec2 grid_size;
uniform vec2 world_size;
uniform float vision_size_factor;
uniform float grid_power;

varying vec2 velocity;
varying float eating;

vec2 rgba_to_grid(in vec4 color)
{
    vec2 vector;
    vector = color.rb + color.ga / 255.0;
    vector *= grid_size;
    return vector;
}

void vertex() {
    VERTEX *= vision_size_factor;
    VERTEX += rgba_to_grid(texture(state_texture, INSTANCE_CUSTOM.xy));
    vec4 color2 = texture(state_texture, INSTANCE_CUSTOM.xy - vec2(0,0.5));
    eating = color2.a;
    
    velocity = texture(state_texture, INSTANCE_CUSTOM.xy - vec2(0,0.5)).rg;
}

void fragment(){
    COLOR = texture(TEXTURE, UV);
    COLOR.a = sqrt(COLOR.a) * eating * 2.0;
    
    //COLOR.a *= 4.0;
    //COLOR.a = round(COLOR.a);
    //COLOR.a /= 4.0;
}