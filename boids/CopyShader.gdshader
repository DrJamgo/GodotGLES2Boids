shader_type canvas_item;
render_mode blend_add, blend_premul_alpha;

void fragment() {
    COLOR = texture(TEXTURE, UV);
}