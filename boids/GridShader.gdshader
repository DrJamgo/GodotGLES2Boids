shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D state_texture;
uniform vec2 grid_size;
uniform vec2 world_size;
uniform float vision_size_factor;
uniform float grid_power;

varying vec2 velocity;

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
    velocity = texture(state_texture, INSTANCE_CUSTOM.xy - vec2(0,0.5)).rg;
}

void fragment(){
    COLOR = texture(TEXTURE, UV);
    COLOR.a = pow(COLOR.a, grid_power) * 0.5;
    if(length(UV - vec2(0.5,0.5)) < (0.25 / vision_size_factor))
        COLOR.a += 0.5;
    COLOR.rg = velocity;
    COLOR.b = 1.0;
}