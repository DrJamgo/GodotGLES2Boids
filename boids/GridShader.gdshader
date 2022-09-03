shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D state_texture;
uniform vec2 grid_size;
uniform vec2 world_size;

varying vec2 speed;

vec2 rgba_to_grid(in vec4 color)
{
    vec2 vector;
    vector = color.rb + color.ga / 255.0;
    vector *= grid_size;
    return vector;
}

vec2 rgba_to_world(in vec4 color)
{
    vec2 vector;
    vector = color.rb + color.ga / 255.0;
    vector *= world_size;
    return vector;
}

vec2 rgba_to_speed(in vec4 color)
{
    return rgba_to_world(color) - world_size / 2.0;
}

void vertex() {
    VERTEX += rgba_to_grid(texture(state_texture, INSTANCE_CUSTOM.xy));
    speed = texture(state_texture, INSTANCE_CUSTOM.xy - vec2(0,0.5)).rg;
}

void fragment(){
    COLOR = texture(TEXTURE, UV);
    COLOR.a = pow(COLOR.a, 1.0) * 0.5;
    if(length(UV - vec2(0.5,0.5)) < 0.05)
        COLOR.a = 1.0;
    COLOR.rg = speed;
    COLOR.b = 1.0;
}