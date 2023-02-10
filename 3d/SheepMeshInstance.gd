extends MultiMeshInstance

export var boids_instance_path : NodePath

func _ready():
    var boids_instance : BoidsInstance = get_node(boids_instance_path)
    if boids_instance:
        var boids_spec : BoidsSpec = boids_instance.boids_spec
        var boids_multimesh = boids_instance.boids_multimesh.multimesh

        multimesh.instance_count = boids_multimesh.instance_count
        
        var shader := (material_override as ShaderMaterial)
        var tile_size = (shader.get_shader_param("tex") as Texture).get_size() / (multimesh.mesh as QuadMesh).size
        tile_size
        for index in range(0, boids_multimesh.instance_count):
            var custom_data : Color = boids_multimesh.get_instance_custom_data(index)
            # enable to make random
            # custom_data.b = float(randi() % 4) / tile_size.y
            if index == 0:
                custom_data.b = 3.0 / tile_size.y
            else:
                custom_data.b = 1.0 / tile_size.y
                
            multimesh.set_instance_custom_data(index, custom_data)
        
        shader.set_shader_param("grid_size", boids_spec.grid_size)
        shader.set_shader_param("world_size", boids_spec.world_size)
        shader.set_shader_param("state_texture", boids_instance.particles_texture)
        shader.set_shader_param("velocity_max", boids_spec.velocity_max)
        shader.set_shader_param("tile_size", tile_size)
    
func _process(delta):
    var boids_instance : BoidsInstance = get_node(boids_instance_path)
    if boids_instance:
        var aabb = boids_instance.boids_aabb
        set_custom_aabb(AABB(Vector3(aabb.position.x,0,aabb.position.y),
                                                Vector3(aabb.size.x,0,aabb.size.y)))
        multimesh.visible_instance_count = boids_instance.get_num_boids()
