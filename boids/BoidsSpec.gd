extends Resource
class_name BoidsSpec

export var world_size := Vector2(256,256)
export var velocity_min := 80.0
export var velocity_max := 100.0
export(float, 0.1, 10.0) var grid_resolution := 1.0
export(int, 1, 16384) var boids_capacity := 100
export var boids_size := 2.0
export var boids_vision := 10.0

export var rule_cohesion := 50.0
export var rule_seperation := 200.0
export var rule_alignment := 1.0
export var rule_target := 10.0
export var rule_colision := 100.0

export var grid_power := 1.5
export var seperation_power := 1.5


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

# const Vector2 _velocity_OFFSET = vec2(127.0 / 255.0, 127.0 / 255.0);

#func rg_to_velocity(color : Color) -> Vector2:
#    return (Vector2(color.r, color.g) - velocity_OFFSET) * (2.0 * velocity_max);

func velocity_to_rg(velocity : Vector2) -> Color:
    velocity /= velocity_max * 2.0
    velocity += Vector2(0.5, 0.5)
    return Color(velocity.x, velocity.y, 0, 0)


func rgba_to_world(color : Color) -> Vector2:
    var vector := Vector2(0,0)
    vector.x = (color.r + color.g / 255.0) * world_size.x
    vector.y = (color.b + color.a / 255.0) * world_size.y
    return vector
