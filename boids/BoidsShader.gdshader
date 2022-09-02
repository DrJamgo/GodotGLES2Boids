shader_type canvas_item;
render_mode blend_add, blend_premul_alpha;

uniform vec2 world_size;
uniform float delta_time = 0.0;

//
// Some helper functions to convert from and to pixel data
//

vec2 rgba_to_world(in vec4 color)
{
    vec2 vector;
    vector = color.rb + color.ga / 256.0;
    vector *= world_size;
    return vector;
}

vec4 world_to_rgba(in vec2 world)
{
    vec4 color;
    world = round(world / world_size * 256.0 * 255.0);
    
    color.r = floor(world.x / 256.0) / 255.0;
    color.g = mod(world.x,  256.0) / 255.0;
    color.b = floor(world.y / 256.0) / 255.0;
    color.a = mod(world.y, 256.0) / 255.0;
    return color;
}

vec2 rgba_to_speed(in vec4 color)
{
    return rgba_to_world(color) - world_size / 2.0;
}

vec4 speed_to_rgba(in vec2 speed)
{
    return world_to_rgba(speed + world_size / 2.0);
}

const float pos_v = 0.25;
const float speed_v = 0.75;

void fragment() {
    COLOR = texture(TEXTURE, UV);
    
    vec2 pos   = rgba_to_world(texture(TEXTURE, vec2(UV.x, pos_v)));
    vec2 speed = rgba_to_speed(texture(TEXTURE, vec2(UV.x, speed_v)));
    
    if(delta_time > 0.0) {
        // Position
        if(UV.y < 0.5) {
            pos += speed * delta_time;
            COLOR = world_to_rgba(pos);
        }
        // speed
        else {
            COLOR = speed_to_rgba(speed);
        }
    }
}