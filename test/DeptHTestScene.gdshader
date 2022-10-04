shader_type spatial;
render_mode cull_disabled, depth_draw_always, unshaded;

uniform sampler2D tex;

void vertex()
{
    VERTEX = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
    VERTEX.x += INSTANCE_CUSTOM.x;
    VERTEX.z += INSTANCE_CUSTOM.y;
}

void fragment()
{
    vec4 color = texture(tex, UV);
    ALBEDO = color.rgb * color.a;
    ALPHA = color.a;
    if(color.a == 0.0)
        discard;
}