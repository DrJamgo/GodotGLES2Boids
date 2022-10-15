extends MultiMeshInstance2D

export var boids_instance_path : NodePath

func _ready():
    var boids_instance : BoidsInstance = get_node(boids_instance_path)
    var boids_spec : BoidsSpec = boids_instance.boids_spec
    var boids_multimesh = boids_instance.boids_multimesh.multimesh

    multimesh.instance_count = boids_multimesh.instance_count
    
    for index in range(0, boids_multimesh.instance_count):
        multimesh.set_instance_custom_data(index, boids_multimesh.get_instance_custom_data(index))
        multimesh.set_instance_transform_2d(index, Transform2D.IDENTITY)
    
    var shader := (material as ShaderMaterial)
    shader.set_shader_param("grid_size", boids_spec.grid_size)
    shader.set_shader_param("world_size", boids_spec.world_size)
    shader.set_shader_param("state_texture", boids_instance.particles_texture)
    shader.set_shader_param("velocity_max", boids_spec.velocity_max)
    
func _process(delta):
    var boids_instance : BoidsInstance = get_node(boids_instance_path)
    multimesh.visible_instance_count = boids_instance.get_num_boids()
