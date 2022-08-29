extends Control

export var boids_capacity := 100
export var grid_size := Vector2(500,500)

const _state_tex_height := 2
onready var _state_text_size = Vector2(boids_capacity, _state_tex_height)

# Called when the node enters the scene tree for the first time.
func _ready():
    $Container/Label_Grid.text += str(grid_size.x) + "x" + str(grid_size.y)
    $Container/VPC_Grid.rect_min_size = grid_size * $Container/VPC_Grid.stretch_shrink
    $Container/VPC_Grid/VP_Grid.size = grid_size
    $Container/VPC_Grid/VP_Grid/GridMultiMesh.setup(boids_capacity)
    
    $Container/Label_State.text += str(_state_text_size.x) + "x" + str(_state_text_size.y)
    $Container/VPC_State.rect_min_size = _state_text_size * $Container/VPC_State.stretch_shrink
    $Container/VPC_State/VP_State.size = _state_text_size
    
    $Container/Label_Copy.text += str(_state_text_size.x) + "x" + str(_state_text_size.y)
    $Container/VPC_Copy.rect_min_size = _state_text_size * $Container/VPC_Copy.stretch_shrink
    $Container/VPC_Copy/VP_Copy.size = _state_text_size

func add_boid(position : Vector2):
    print(position)
    $Container/VPC_State/VP_State.add_boid(position)

func _process(delta):
    rect_min_size = get_viewport().size

func _input(event):
    var mouse_event := event as InputEventMouseButton
    if mouse_event and mouse_event.pressed:
        add_boid(mouse_event.position - $Container/VPC_Grid.rect_position)
