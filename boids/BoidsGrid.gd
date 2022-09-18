# MIT License
# Copyright (c) 2022 DrJamgo

extends Viewport

var _external_agents := []
var _spec : BoidsSpec

func setup(spec : BoidsSpec, particles_texture : ViewportTexture):
    $ColorRect.rect_min_size = spec.grid_size
    $GridMultiMesh.setup(spec, particles_texture)
    _spec = spec

func _process(delta):
    for agent in _external_agents:
        var node : Node2D = agent["node"]
        var sprite : Sprite = agent["sprite"]
        var diff = (node.position - sprite.position) / delta
        var rg = _spec.velocity_to_rg(diff);
        sprite.self_modulate.r = rg.r
        sprite.self_modulate.g = rg.g
        sprite.position = node.position

func add_external_agent(node : Node2D, radius : float, isFriend : bool):
    var sprite = Sprite.new()
    sprite.texture = preload("res://boids/radial_gradient.png")
    sprite.scale = (Vector2(2,2) * _spec.grid_resolution * radius) / sprite.texture.get_size()
    sprite.position = node.position
    sprite.self_modulate.b = 1.0 if isFriend else 0.0
    _external_agents.append({"sprite":sprite, "position":node.position, "node":node})
    add_child(sprite)
