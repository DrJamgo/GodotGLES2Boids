extends Sprite
class_name BoidsExternalAgent2D

var boids_spec : BoidsSpec
var radius := 10.0 setget _set_radius
var isFriend := true setget _set_isFriend
var world_position := Vector2(0,0)

func _set_radius(_radius : float):
    radius = _radius
    scale = (Vector2(2,2) * boids_spec.grid_resolution * radius) / texture.get_size()

func _set_isFriend(_isFriend : bool):
    isFriend = _isFriend
    self_modulate.b = 1.0 if isFriend else 0.0

func _process(delta):
    var grid_position := boids_spec.world_to_grid(world_position)
    var diff = (grid_position - position) / delta / boids_spec.grid_resolution
    var rg = boids_spec.velocity_to_rg(diff);
    self_modulate.r = rg.r
    self_modulate.g = rg.g
    position = grid_position
