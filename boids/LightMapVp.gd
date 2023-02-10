# MIT License
# Copyright (c) 2022 DrJamgo

extends Viewport

var _external_agents := []
var _spec : BoidsSpec

func setup(spec : BoidsSpec, particles_texture : ViewportTexture):
    _spec = spec.duplicate()
    _spec.boids_vision = 64.0
    
    $GridMultiMesh.setup(_spec, particles_texture)
    
