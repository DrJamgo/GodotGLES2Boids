extends MultiMeshInstance2D

export var state_texture : ViewportTexture

func setup(num_boids : int):
    multimesh.instance_count = num_boids
    multimesh.visible_instance_count = 0
    
    for index in range(0, num_boids):
        multimesh.set_instance_custom_data(index, Color((float(index) + 0.25) / float(num_boids) / 2.0, 0.75, 0.0, 0.0))
        multimesh.set_instance_transform_2d(index, Transform2D.IDENTITY)

func _on_VP_State_boid_added():
    multimesh.visible_instance_count += 1
    pass
