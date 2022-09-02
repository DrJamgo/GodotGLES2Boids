shader_type canvas_item;
render_mode blend_add, blend_premul_alpha;

uniform vec2 world_size;
uniform vec2 grid_size;
uniform float delta_time = 0.0;
uniform sampler2D grid_texture;
uniform float boids_vision;

//
// Boids rules
//
uniform float rule_seperation = 10.0;
uniform float rule_coherence = 1.0;
uniform float rule_alignment = 1.0;

//
// Some helper functions to convert from and to pixel data
//

vec2 rgba_to_world(in vec4 color)
{
    vec2 vector;
    vector = color.rb + color.ga / 255.0;
    vector *= world_size;
    return vector;
}

vec4 world_to_rgba(in vec2 world)
{
    vec4 color;
    world = round(world / world_size * 255.0 * 255.0);
    
    color.r = floor(world.x / 255.0) / 255.0;
    color.g = mod(world.x,  255.0) / 255.0;
    color.b = floor(world.y / 255.0) / 255.0;
    color.a = mod(world.y, 255.0) / 255.0;
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

highp vec2 world_to_grid(in highp vec2 world)
{
    vec2 grid = world / world_size;
    grid.y = 1.0 - grid.y;
    return grid;
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
            float self = texture(grid_texture, world_to_grid(pos)).a;
            vec2 gradient = vec2(0.0,0.0);
            for(int y = -2; y <= 2; y++) {
                for(int x = -2; x <= 2; x++) {
                    vec2 dir = vec2(float(x), float(y)) * boids_vision * 0.5;
                    gradient += dir * (1.0 - texture(grid_texture, world_to_grid(pos + dir)).a);
                }
            }
            gradient /= boids_vision;
            
            speed = gradient * rule_seperation;
            COLOR = speed_to_rgba(speed);
        }
    }
}