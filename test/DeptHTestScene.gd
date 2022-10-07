extends Spatial

func _ready():
    #$SheepMeshInstance.multimesh = $BoidsInstance.boids_multimesh

    #$BoidsInstance.set_target(Vector2(0,0))
    var statricgrid : Texture = preload("res://assets/level1.png")
    $BoidsInstance.static_grid = statricgrid
    
    $DebugGrdTexture.texture = $BoidsInstance.dynamic_grid
    $DebugGrdTexture.pixel_size = 1.0 / $BoidsInstance.boids_spec.grid_resolution
    #DebugGrdTexture.rect_scale = Vector2(1,1) / $BoidsInstance.boids_spec.grid_resolution
    #$DebugStaticTexture.texture = $BoidsInstance.static_grid
    #$DebugStaticTexture.rect_scale =  $BoidsInstance.boids_spec.world_size / statricgrid.get_size()
    
    $Player.boids_agent = $BoidsInstance.add_external_agent(24, true)
    $Doggo.boids_agent = $BoidsInstance.add_external_agent(64, false)
    
    var boids_spec : BoidsSpec = $BoidsInstance.boids_spec
    var boids_multimesh = $BoidsInstance.boids_multimesh.multimesh
    
    $BoidsInstance.add_boids_with_spread($Player.get_2d_position(), 100, Vector2(200,200))
    
    #$Panel/Sliders.setup(boids_spec)
    $SheepMeshInstance.multimesh.instance_count = boids_multimesh.instance_count
    
    for index in range(0, boids_multimesh.instance_count):
        $SheepMeshInstance.multimesh.set_instance_custom_data(index, boids_multimesh.get_instance_custom_data(index))
    
    var shader := ($SheepMeshInstance.material_override as ShaderMaterial)
    shader.set_shader_param("grid_size", boids_spec.grid_size)
    shader.set_shader_param("world_size", boids_spec.world_size)
    shader.set_shader_param("state_texture", $BoidsInstance.particles_texture)
    shader.set_shader_param("velocity_max", boids_spec.velocity_max)
    
func _process(delta):
    $SheepMeshInstance.multimesh.visible_instance_count = $BoidsInstance.get_num_boids()

func _physics_process(delta):
    $BoidsInstance.set_target(Vector2($Player.transform.origin.x, $Player.transform.origin.z))
