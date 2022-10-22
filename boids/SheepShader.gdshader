shader_type canvas_item;
render_mode blend_add, blend_premul_alpha;

uniform vec2 world_size;
uniform vec2 grid_size;
uniform float delta_time = 0.0;
uniform sampler2D dynamic_grid;
uniform sampler2D static_grid;
uniform float boids_vision;
uniform float boids_size;
uniform float seperation_power;

//
// Boids rules
//
uniform float rule_seperation = 20.0;
uniform float rule_cohesion = 5.0;
uniform float rule_alignment = 1.0;
uniform float rule_target = 1.0;
uniform float rule_attraction = 1.0;
uniform float rule_colision = 100.0;
uniform vec3  target = vec3(0,0,0); // active if Z > 0

uniform float velocity_min = 20.0;
uniform float velocity_max = 50.0;

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

const vec2 velocity_OFFSET = vec2(127.0 / 255.0, 127.0 / 255.0);

vec2 rg_to_velocity(in vec2 color)
{
    return (color.rg - velocity_OFFSET) * (2.0 * velocity_max);
}

vec2 velocity_to_rg(in vec2 velocity)
{
    return (velocity / (2.0 * velocity_max)) + velocity_OFFSET;
}

highp vec2 world_to_grid(in highp vec2 world)
{
    vec2 grid = world / world_size;
    grid.y = 1.0 - grid.y;
    return grid;
}

float choas_func(in float seed) {
    // Idea from: https://humphryscomputing.com/Notes/Neural/chaos.html
    return (1.0 + sin(1.0 / mod(seed, 0.001))) / 2.0;
}

const float pos_v = 0.25;
const float velocity_v = 0.75;
const float PI = 3.14159;
const float ANGLE_NUMSTEPS = 16.0;
const float ANGLE_STEP = PI / ANGLE_NUMSTEPS * 2.0;
const float RADIUS_NUM_STEPS = 8.0;
const float RADIUS_STEP = 1.0 / RADIUS_NUM_STEPS;

void fragment() {
    COLOR = texture(TEXTURE, UV);
    
    vec2 pos   = rgba_to_world(texture(TEXTURE, vec2(UV.x, pos_v)));
    vec2 velocity = rg_to_velocity(texture(TEXTURE, vec2(UV.x, velocity_v)).rg);
    float hunger = 1.0 - COLOR.a;
    
    if(delta_time > 0.0 && length(COLOR) > 0.0) {
        // Position
        if(UV.y < 0.5) {
            pos += velocity * delta_time;
            COLOR = world_to_rgba(pos);
        }
        // velocity
        else {
            float self = texture(dynamic_grid, world_to_grid(pos)).a;
            vec2 gradient = vec2(0.0,0.0);
            vec2 repulsion = vec2(0.0,0.0);
            vec2 density  = vec2(0.0,0.0);
            vec2 attraction = vec2(0.0,0.0);
            vec2 heading = vec2(0,0);
            float max_value = 0.0;
            float gradien_sum = 0.0;
            float negative = 0.0;
            
            for(float r = RADIUS_STEP; r <= 1.0; r += RADIUS_STEP) {
                float radius = r * (boids_vision - boids_size) + boids_size;
                float gradient_weight = pow(1.0 - r, seperation_power);
                gradien_sum += gradient_weight * ANGLE_NUMSTEPS;
                
                for(float angle = -PI; angle < PI; angle += ANGLE_STEP) {
                
                    vec2 dir = vec2(cos(angle), sin(angle)) * radius;
                    vec2 grid_uv = world_to_grid(pos + dir);
                    vec4 rgba = texture(dynamic_grid, grid_uv);
                    vec4 rgba_static = texture(static_grid, grid_uv);
                    float alpha =  (rgba.b - 0.5);
                    
                    gradient -= normalize(dir) * gradient_weight * abs(alpha);
                    repulsion -= normalize(dir) * gradient_weight * length(rgba_static.rb);
                    attraction += normalize(dir) * rgba_static.g;
                    
                    if(alpha >= 0.0) {
                        heading += rg_to_velocity(rgba.rg);
                    }
                    
                    density += normalize(dir) * alpha * r;
                    if(alpha < 0.0) {
                        negative += (0.5 - alpha) * 2.0;
                    }
                }
            }
            
            // normalize values
            gradient /= gradien_sum;
            repulsion /= gradien_sum;
            heading /= (ANGLE_NUMSTEPS * RADIUS_NUM_STEPS);
            density /= (ANGLE_NUMSTEPS * RADIUS_NUM_STEPS);
            negative /= (ANGLE_NUMSTEPS * RADIUS_NUM_STEPS);
            attraction /= (ANGLE_NUMSTEPS * RADIUS_NUM_STEPS);
            
            float fear_factor = (1.0 + negative);
            
            velocity = vec2(mod(TIME*UV.x*1389.0, 2.0) - 1.0, mod(TIME*UV.x*7821.0, 2.0) - 1.0) * 1.0;
            velocity += gradient * rule_seperation;
            velocity += density * rule_cohesion * fear_factor;
            velocity += heading * rule_alignment;
            
            // extra behavour on static grid
            velocity += attraction * rule_attraction * max(0.0, 1.0 - negative * 4.0) * hunger;
            velocity += repulsion * rule_colision;
            
            if(target.z > 0.0) {
                velocity += normalize(target.xy - pos) * rule_target;
            }
            
            float _velocity_min = velocity_min * fear_factor;
            
            // check velocity limits
            float velocity_abs = length(velocity);
            if(velocity_abs == 0.0) {
                // velocity = vec2(velocity_min, 0);
            }
            else if(velocity_abs < _velocity_min) {
                velocity *= _velocity_min / velocity_abs;
            }
            else if(velocity_abs > velocity_max){
                velocity *= velocity_max / velocity_abs;
            }
            
            // process eating and hunger
            bool eating_phase = mod(hunger * 16.0, 2.0) > 1.0;
            
            if(eating_phase) {
                if(negative < 0.01 && texture(static_grid, world_to_grid(pos)).g > 0.0) {
                    velocity = vec2(0,0);
                    COLOR.a += delta_time / 2.0 / 4.0 * choas_func(UV.x+TIME);
                }
            }
            else {
                COLOR.a += delta_time * choas_func(UV.x+TIME) / 2.0 / 2.0;
            }
            
            COLOR.rg = velocity_to_rg(velocity);
            COLOR.b = mod(length(velocity) * delta_time / 8.0 + COLOR.b, 1.0);
        }
    }
}