extends Sprite

var _spec : BoidsSpec

var _do_one_step := false

func setup(boids_spec : BoidsSpec):
    _spec = boids_spec
    var shader := (material as ShaderMaterial)
    
    shader.set_shader_param("world_size", _spec.world_size)
    shader.set_shader_param("grid_size", _spec.grid_size)
    shader.set_shader_param("world_size", _spec.world_size)
    shader.set_shader_param("boids_vision", _spec.boids_vision)
    shader.set_shader_param("speed_min", _spec.speed_min)
    shader.set_shader_param("speed_max", _spec.speed_max)

func set_target(position : Vector2):
    var shader := (material as ShaderMaterial)
    if position:
        shader.set_shader_param("target", Vector3(position.x, position.y, 1.0))
    else:
        shader.set_shader_param("target", Vector3(0,0,0))

func _process(delta):
    (material as ShaderMaterial).set_shader_param("delta_time", delta)
    if _do_one_step:
        (material as ShaderMaterial).set_shader_param("delta_time", delta)
        yield(get_tree(), "idle_frame")
        (material as ShaderMaterial).set_shader_param("delta_time", 0.0)
        _do_one_step = false

func _on_ButtonStep_pressed():
    _do_one_step = true
