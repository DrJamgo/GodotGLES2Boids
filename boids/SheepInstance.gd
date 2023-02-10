# MIT License
# Copyright (c) 2022 DrJamgo
extends BoidsInstance
class_name SheepInstance

onready var lightmap : ViewportTexture = $LightMapVP.get_texture()

func _ready():
    var spec := (boids_spec as BoidsSpec)
    $LightMapVP.size = spec.grid_size
    $LightMapVP.setup(spec, particles_texture)

    $LightMapVP/GridMultiMesh.multimesh = $BoidsGrid/GridMultiMesh.multimesh
