shader_type spatial;
render_mode cull_disabled, depth_draw_always, unshaded;

uniform sampler2D tex;
uniform mat3 transform;

void vertex()
{
    VERTEX = transform * VERTEX;
    VERTEX.x += INSTANCE_CUSTOM.x;
    VERTEX.z += INSTANCE_CUSTOM.z;
}

void fragment()
{
    vec4 color = texture(tex, UV);
    ALBEDO = color.rgb * color.a;
    ALPHA = color.a;
    if(color.a == 0.0)
        discard;
}