extends Node

signal boids_count_changed(amount)

export var boids_spec : Resource

func _ready():
    var spec := (boids_spec as BoidsSpec)
    $VP_Grid.size = spec.grid_size
    $VP_Grid.setup(spec)
    
    $BoidsParticles.setup(spec)
    
    $VP_Copy.size = spec.state_size

func _on_BoidsParticles_boids_count_changed(amount):
    emit_signal("boids_count_changed", amount)

func get_num_boids() -> int:
    return $BoidsParticles.num_boids

func add_boids_with_spread(position : Vector2, amount : int, spread : Vector2):
    $BoidsParticles.add_boids_with_spread(position, amount, spread)
    
func set_target(position):
    $BoidsParticles.set_target(position)
