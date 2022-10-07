# MIT License
# Copyright (c) 2022 DrJamgo

extends Viewport

var _spec : BoidsSpec

func setup(spec : BoidsSpec, particles_texture : ViewportTexture):
    $ColorRect.rect_min_size = spec.grid_size
    $GridMultiMesh.setup(spec, particles_texture)
    _spec = spec

func add_external_agent(radius : float, isFriend : bool) -> BoidsExternalAgent2D:
    var agent := preload("res://boids/BoidsExternalAgent2D.gd").new()
    agent.texture = preload("res://boids/radial_gradient.png")
    agent.boids_spec = _spec
    agent.radius = radius
    agent.isFriend = isFriend
    add_child(agent)
    
    return agent
