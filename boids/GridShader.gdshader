shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D state_texture;
uniform vec2 world_size;

const vec2 max_value = vec2(256.0, 256.0);

vec2 rgba_to_vector2(in vec4 color)
{
    vec2 vector;
    vector.x = (color.r * 256.0 + color.g) / world_size.x * max_value.x;
    vector.y = (color.b * 256.0 + color.a) / world_size.y * max_value.y;
    return vector;
}

void vertex() {
    VERTEX += rgba_to_vector2(texture(state_texture, INSTANCE_CUSTOM.xy));
}