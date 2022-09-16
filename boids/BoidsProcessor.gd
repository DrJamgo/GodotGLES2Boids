# MIT License
# Copyright (c) 2022 DrJamgo

extends Sprite

var _spec : BoidsSpec

func setup(boids_spec : BoidsSpec, copy_texture : ViewportTexture, grid_texture : ViewportTexture):
    _spec = boids_spec
    var shader := (material as ShaderMaterial)
    
    shader.set_shader_param("world_size", _spec.world_size)
    shader.set_shader_param("grid_size", _spec.grid_size)
    shader.set_shader_param("world_size", _spec.world_size)
    shader.set_shader_param("grid_texture", grid_texture)
    texture = copy_texture

func set_target(position : Vector2):
    var shader := (material as ShaderMaterial)
    if position:
        shader.set_shader_param("target", Vector3(position.x, position.y, 1.0))
    else:
        shader.set_shader_param("target", Vector3(0,0,0))

func _process(delta):
    var shader := (material as ShaderMaterial)
    shader.set_shader_param("delta_time", delta)
    shader.set_shader_param("boids_vision", _spec.boids_vision)
    shader.set_shader_param("boids_size", _spec.boids_size)
    shader.set_shader_param("rule_cohesion", _spec.rule_cohesion)
    shader.set_shader_param("rule_seperation", _spec.rule_seperation)
    shader.set_shader_param("rule_alignment", _spec.rule_alignment)
    shader.set_shader_param("rule_target", _spec.rule_target)
    shader.set_shader_param("seperation_power", _spec.seperation_power)
    shader.set_shader_param("velocity_min", _spec.velocity_min)
    shader.set_shader_param("velocity_max", _spec.velocity_max)
