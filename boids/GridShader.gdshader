shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D state_texture;

void vertex() {
    VERTEX += texture(state_texture, INSTANCE_CUSTOM.xy).xy * 255.0;
}