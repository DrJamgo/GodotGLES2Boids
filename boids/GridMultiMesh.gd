extends MultiMeshInstance2D

export var state_texture : ViewportTexture

func setup(boids_spec : BoidsSpec):
    var num_boids = boids_spec.boids_capacity
    
    multimesh.instance_count = num_boids
    multimesh.visible_instance_count = 0
    
    for index in range(0, num_boids):
        multimesh.set_instance_custom_data(index, Color((float(index) + 0.25) / float(num_boids) / 2.0, 0.75, 0.0, 0.0))
        multimesh.set_instance_transform_2d(index, Transform2D.IDENTITY)
    
    (material as ShaderMaterial).set_shader_param("world_size", boids_spec.world_size)

func _on_VP_State_boid_added():
    multimesh.visible_instance_count += 1
    pass
