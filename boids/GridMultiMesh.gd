# MIT License
# Copyright (c) 2022 DrJamgo

class_name BoidsMultimeshInstance2D
extends MultiMeshInstance2D

var _spec : BoidsSpec

func setup(boids_spec : BoidsSpec, particles_texture : ViewportTexture):
    var num_boids = boids_spec.boids_capacity
    _spec = boids_spec
    multimesh.instance_count = num_boids
    multimesh.visible_instance_count = 0
    
    for index in range(0, num_boids):
        multimesh.set_instance_custom_data(index, Color((float(index) + 0.5) / float(num_boids), 0.75, 0.0, 0.0))
        multimesh.set_instance_transform_2d(index, Transform2D.IDENTITY)
    
    var shader := (material as ShaderMaterial)
    shader.set_shader_param("grid_size", boids_spec.grid_size)
    shader.set_shader_param("world_size", boids_spec.world_size)
    shader.set_shader_param("state_texture", particles_texture)

func _process(delta):
    var shader := (material as ShaderMaterial)
    (multimesh.mesh as QuadMesh).size = Vector2(1,1) * _spec.boids_size * _spec.grid_resolution
    shader.set_shader_param("vision_size_factor", _spec.boids_vision / _spec.boids_size)
    shader.set_shader_param("grid_power", _spec.grid_power)

func _on_BoidsInstance_boids_count_changed(amount):
    multimesh.visible_instance_count = amount
