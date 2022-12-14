extends Resource
class_name BoidsSpec

export var world_size := Vector2(256,256)
export var velocity_min := 80.0
export var velocity_max := 100.0
export(float, 0.1, 10.0) var grid_resolution := 1.0
export(int, 1, 16384) var boids_capacity := 100
export var boids_size := 2.0
export var boids_vision := 10.0

export var rule_cohesion := 10.0
export var rule_seperation := 10.0
export var rule_alignment := 1.0
export var rule_target := 1.0

const _data_height := 2

var grid_size : Vector2 setget , _get_grid_size
var state_size : Vector2 setget , _get_state_size

func _get_grid_size() -> Vector2:
    grid_size = world_to_grid(world_size)
    return grid_size
    
func _get_state_size() -> Vector2:
    state_size.x = boids_capacity
    state_size.y = _data_height
    return state_size

const max_value = Vector2(255.0, 255.0) * Vector2(255.0, 255.0)

func world_to_grid(world : Vector2) -> Vector2:
    return world * grid_resolution
    
func grid_to_world(grid : Vector2) -> Vector2:
    return grid / grid_resolution

func world_to_rgba(vector : Vector2) -> Color:
    vector *= (max_value / world_size).round();
    var color := Color(int(vector.x) / 255, int(vector.x) % 255, 
                       int(vector.y) / 255, int(vector.y) % 255)
    return color

func rgba_to_world(color : Color) -> Vector2:
    var vector := Vector2(0,0)
    vector.x = (color.r * 255.0 + color.g) * world_size.x / max_value.x
    vector.y = (color.b * 255.0 + color.a) * world_size.y / max_value.y
    return vector
