shader_type spatial;
render_mode world_vertex_coords, cull_disabled, depth_draw_always, unshaded;

uniform sampler2D state_texture;
uniform vec2 grid_size;
uniform vec2 world_size;
uniform float velocity_max;

uniform sampler2D tex;

varying vec2 velocity;
varying float eating;

const vec2 velocity_OFFSET = vec2(127.0 / 255.0, 127.0 / 255.0);
const float PI = 3.14159;

vec2 rg_to_velocity(in vec2 color)
{
    return (color.rg - velocity_OFFSET) * (2.0 * velocity_max);
}

vec2 rgba_to_world(in vec4 color)
{
    vec2 vector;
    vector = color.rb + color.ga / 255.0;
    vector *= world_size;
    return vector;
}

void vertex() {
    VERTEX.xz += rgba_to_world(texture(state_texture, INSTANCE_CUSTOM.xy));
    vec4 color2 = texture(state_texture, INSTANCE_CUSTOM.xy - vec2(0,0.5));
    velocity = rg_to_velocity(color2.rg);
    eating = color2.a;
    VERTEX.z += sin(color2.b * 2.0 * PI) * (length(velocity) / velocity_max) * 2.0;
    VERTEX.xyz = round(VERTEX.xyz);
}

void fragment() {
    
    vec2 uv = UV;
    uv.x /= 9.0;
    float frame = 0.0;
    if(length(velocity) > 0.0) {
        float angle = atan(velocity.y, velocity.x) + PI;
        frame = mod(4.0 + round(angle / 2.0 / PI * 8.0), 8.0);
    }
    else {
        frame = 8.0;
    }
    uv.x += frame / 9.0;

    vec4 color = texture(tex, uv);
    if (color.a == 0.0)
        discard;
    ALBEDO = color.rgb * color.a;
    ALPHA = color.a;
}