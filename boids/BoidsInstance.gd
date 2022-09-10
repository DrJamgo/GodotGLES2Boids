# MIT License
# Copyright (c) 2022 DrJamgo

class_name BoidsInstance
extends Node

signal boids_count_changed(amount)

export var boids_spec : Resource

onready var spatial_texture : ViewportTexture = $BoidsSpatial.get_texture()
onready var particles_texture : ViewportTexture = $BoidsParticles.get_texture()
onready var copy_texture : ViewportTexture = $Copy.get_texture()

func _ready():
    var spec := (boids_spec as BoidsSpec)
    $BoidsSpatial.size = spec.grid_size
    $BoidsSpatial.setup(spec)
    
    $BoidsParticles.setup(spec)
    
    $Copy.size = spec.state_size

func _on_BoidsParticles_boids_count_changed(amount):
    emit_signal("boids_count_changed", amount)

func get_num_boids() -> int:
    return $BoidsParticles.num_boids

func add_boids_with_spread(position : Vector2, amount : int, spread : Vector2):
    $BoidsParticles.add_boids_with_spread(position, amount, spread)
    
func set_target(position):
    $BoidsParticles.set_target(position)
