# MIT License
# Copyright (c) 2022 DrJamgo

class_name BoidsInstance
extends Node

signal boids_count_changed(num_boids)

export var boids_spec : Resource
export var static_grid : Texture setget set_static_grid

onready var dynamic_grid : ViewportTexture = $BoidsGrid.get_texture()
onready var particles_texture : ViewportTexture = $BoidsParticles.get_texture()
onready var copy_texture : ViewportTexture = $Copy.get_texture()
onready var boids_multimesh : BoidsMultimeshInstance2D = $BoidsGrid/GridMultiMesh

var boids_aabb : Rect2
var fullnes_avg : float

func _ready():
    var spec := (boids_spec as BoidsSpec)
    $BoidsGrid.size = spec.grid_size
    $BoidsGrid.setup(spec, particles_texture)
    
    $BoidsParticles.setup(spec, copy_texture, dynamic_grid)
    
    $Copy.size = spec.state_size
    $Copy/BoidsTexture.texture = particles_texture
    
    $Aggregator.setup(spec, particles_texture)

func _process(delta):
    var image : Image = $Aggregator.get_texture().get_data()
    image.lock()
    
    var spec := (boids_spec as BoidsSpec)
    boids_aabb.position = spec.rgba_to_world(image.get_pixel(1,0))
    boids_aabb.size = spec.rgba_to_world(image.get_pixel(2,0)) - boids_aabb.position
    
    fullnes_avg = image.get_pixel(3,1).a
    
    image.unlock()

func _on_BoidsParticles_boids_count_changed(amount):
    emit_signal("boids_count_changed", get_num_boids())

func get_num_boids() -> int:
    return $BoidsParticles.num_boids

func add_boids_with_spread(position : Vector2, amount : int, spread : Vector2):
    $BoidsParticles.add_boids_with_spread(position, amount, spread)
    
func add_external_agent(radius : float, isFriend : bool) -> BoidsExternalAgent2D:
    return $BoidsGrid.add_external_agent(radius, isFriend)
    
func set_static_grid(texture : Texture):
    static_grid = texture
    $BoidsParticles.set_static_grid(texture)

func set_target(position):
    $BoidsParticles.set_target(position)
