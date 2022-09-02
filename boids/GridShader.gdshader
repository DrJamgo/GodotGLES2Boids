shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D state_texture;
uniform vec2 grid_size;
uniform vec2 world_size;

vec2 rgba_to_grid(in vec4 color)
{
    vec2 vector;
    vector = color.rb + color.ga / 255.0;
    vector *= grid_size;
    return vector;
}

void vertex() {
    VERTEX += rgba_to_grid(texture(state_texture, INSTANCE_CUSTOM.xy));
}
