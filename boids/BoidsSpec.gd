extends Resource
class_name BoidsSpec

export var boids_capacity := 100
export var grid_size := Vector2(500,500)
export var world_size := Vector2(256,256)

const max_value = Vector2(255.0, 255.0) * Vector2(256.0, 256.0)

func Vector2_to_RGBA(vector : Vector2) -> Color:
    var color : Color
    vector *= (max_value / world_size).round();
    
    color.r = int(vector.x) / 256
    color.g = int(vector.x) % 256
    color.b = int(vector.y) / 256
    color.a = int(vector.y) % 256
    return color

func RGBA_to_Vector2(color : Color) -> Vector2:
    var vector : Vector2
    vector.x = (color.r * 256.0 + color.g) * world_size.x / max_value.x
    vector.y = (color.b * 256.0 + color.a) * world_size.y / max_value.y
    return vector
