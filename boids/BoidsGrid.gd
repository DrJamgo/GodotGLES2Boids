# MIT License
# Copyright (c) 2022 DrJamgo

extends Viewport

func setup(spec : BoidsSpec, particles_texture : ViewportTexture):
    $ColorRect.rect_min_size = spec.grid_size
    $GridMultiMesh.setup(spec, particles_texture)
