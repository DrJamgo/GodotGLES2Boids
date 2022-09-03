extends Resource
class_name BoidsSpec

export var world_size := Vector2(256,256)
export var speed_min := 80.0
export var speed_max := 100.0
export var grid_resolution := 1.0
export var boids_capacity := 100
export var boids_size := 2.0
export var boids_vision := 10.0

var grid_size : Vector2 setget , _get_grid_size

func _get_grid_size() -> Vector2:
    grid_size = world_to_grid(world_size)
    return grid_size

const max_value = Vector2(255.0, 255.0) * Vector2(255.0, 255.0)

func world_to_grid(world : Vector2) -> Vector2:
    return world * grid_resolution
    
func grid_to_world(grid : Vector2) -> Vector2:
    return grid / grid_resolution

func world_to_rgba(vector : Vector2) -> Color:
    var color : Color
    vector *= (max_value / world_size).round();
    
    color.r = int(vector.x) / 255
    color.g = int(vector.x) % 255
    color.b = int(vector.y) / 255
    color.a = int(vector.y) % 255
    return color

func rgba_to_world(color : Color) -> Vector2:
    var vector : Vector2
    vector.x = (color.r * 255.0 + color.g) * world_size.x / max_value.x
    vector.y = (color.b * 255.0 + color.a) * world_size.y / max_value.y
    return vector
