extends Control

onready var spec := ($BoidsInstance.boids_spec as BoidsSpec)

# Called when the node enters the scene tree for the first time.
func _ready():
    $Container/Label_Grid.text += str(spec.grid_size.x) + "x" + str(spec.grid_size.y)
    $Container/Label_Grid.text += "  World:" + str(spec.world_size.x) + "x" + str(spec.world_size.y)
    $Container/VPC_Grid.texture  = $BoidsInstance.spatial_texture
    $Container/VPC_Grid.rect_min_size = spec.grid_size * $Container/VPC_Grid.stretch_shrink

    $Container/Label_State.text += str(spec.state_size.x) + "x" + str(spec.state_size.y)
    $Container/VPC_State.texture  = $BoidsInstance.particles_texture
    $Container/VPC_State.rect_min_size = spec.state_size * $Container/VPC_State.stretch_shrink
    
    $Container/Label_Copy.text += str(spec.state_size.x) + "x" + str(spec.state_size.y)
    $Container/VPC_Copy.texture = $BoidsInstance.copy_texture
    $Container/VPC_Copy.rect_min_size = spec.state_size * $Container/VPC_Copy.stretch_shrink
    
    _update_labels()
    
    set_target(spec.grid_size / 2.0)

func _update_labels():
    $Container/Label_Boids.text = "Boids: " + str($BoidsInstance.get_num_boids()) + "/" + str(spec.boids_capacity)
    $Container/Label_Boids.text += "   FPS: " + str(Engine.get_frames_per_second())

func _process(delta):
    rect_min_size = get_viewport().size
    _update_labels()

func set_target(position):
    $BoidsInstance.set_target(position / spec.grid_resolution)
    $Container/VPC_Grid.set_target(position)

func add_boid(position : Vector2):
    $BoidsInstance.add_boids_with_spread(position / spec.grid_resolution, 50, Vector2(20,20))

func get_state_texture() -> ViewportTexture:
    return $Container/VPC_State/VP_State.get_texture()

func _on_VPC_Grid_clicked(position, index):
    if index == BUTTON_LEFT:
        add_boid(position)
    else:
        set_target(position)
        
