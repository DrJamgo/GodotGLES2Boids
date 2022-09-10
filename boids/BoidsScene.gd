extends Control

export var boids_spec : Resource = null

# Called when the node enters the scene tree for the first time.
func _ready():
    
    var spec := (boids_spec as BoidsSpec)

    $Container/Label_Grid.text += str(spec.grid_size.x) + "x" + str(spec.grid_size.y)
    $Container/Label_Grid.text += "  World:" + str(spec.world_size.x) + "x" + str(spec.world_size.y)
    $Container/VPC_Grid.rect_min_size = spec.grid_size * $Container/VPC_Grid.stretch_shrink
    $Container/VPC_Grid/VP_Grid.size = spec.grid_size
    $Container/VPC_Grid/VP_Grid.setup(spec)
    
    
    $Container/VPC_Grid.connect("clicked", self, "add_boid")
    
    $Container/Label_State.text += str(spec.data_size.x) + "x" + str(spec.data_size.y)
    $Container/VPC_State.setup(spec)
    
    $Container/Label_Copy.text += str(spec.data_size.x) + "x" + str(spec.data_size.y)
    $Container/VPC_Copy.rect_min_size = spec.data_size * $Container/VPC_Copy.stretch_shrink
    $Container/VPC_Copy/VP_Copy.size = spec.data_size
    
    _update_labels()
    
    set_target(boids_spec.grid_size / 2.0)

func _update_labels():
    $Container/Label_Boids.text = "Boids: " + str($Container/VPC_State/BoidsParticles.num_boids) + "/" + str(boids_spec.boids_capacity)
    $Container/Label_Boids.text += "   FPS: " + str(Engine.get_frames_per_second())

func _process(delta):
    rect_min_size = get_viewport().size
    _update_labels()

func set_target(position):
    $Container/VPC_State/BoidsParticles.set_target(position / boids_spec.grid_resolution)
    $Container/VPC_Grid.set_target(position)

func add_boid(position : Vector2):
    $Container/VPC_State/BoidsParticles.add_boid(position / boids_spec.grid_resolution, 50, Vector2(20,20))

func get_multimesh() -> MultiMesh:
    return $Container/VPC_Grid/VP_Grid/GridMultiMesh.multimesh

func get_state_texture() -> ViewportTexture:
    return $Container/VPC_State/VP_State.get_texture()

func _on_VPC_Grid_clicked(position, index):
    if index == BUTTON_LEFT:
        add_boid(position)
    else:
        set_target(position)
        
