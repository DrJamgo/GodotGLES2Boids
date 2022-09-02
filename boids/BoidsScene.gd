extends Control

export var boids_spec : Resource = null
const _state_tex_height := 2

# Called when the node enters the scene tree for the first time.
func _ready():
    var _state_text_size = Vector2(boids_spec.boids_capacity, _state_tex_height)
    
    $Container/Label_Grid.text = "Grid: " + str(boids_spec.grid_size.x) + "x" + str(boids_spec.grid_size.y)
    $Container/Label_Grid.text += "  World:" + str(boids_spec.world_size.x) + "x" + str(boids_spec.world_size.y)
    $Container/VPC_Grid.rect_min_size = boids_spec.grid_size * $Container/VPC_Grid.stretch_shrink
    $Container/VPC_Grid/VP_Grid.size = boids_spec.grid_size
    $Container/VPC_Grid/VP_Grid/GridMultiMesh.setup(boids_spec)
    
    $Container/VPC_Grid.connect("clicked", self, "add_boid")
    
    $Container/Label_State.text += str(_state_text_size.x) + "x" + str(_state_text_size.y)
    $Container/VPC_State.rect_min_size = _state_text_size * $Container/VPC_State.stretch_shrink
    $Container/VPC_State/VP_State.size = _state_text_size
    $Container/VPC_State/VP_State.setup(boids_spec)
    
    $Container/Label_Copy.text += str(_state_text_size.x) + "x" + str(_state_text_size.y)
    $Container/VPC_Copy.rect_min_size = _state_text_size * $Container/VPC_Copy.stretch_shrink
    $Container/VPC_Copy/VP_Copy.size = _state_text_size

func add_boid(position : Vector2):
    $Container/VPC_State/VP_State.add_boid(position / boids_spec.grid_resolution, 20, Vector2(20,20))

func _process(delta):
    rect_min_size = get_viewport().size
