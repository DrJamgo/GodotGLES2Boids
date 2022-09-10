extends Viewport

func setup(boids_spec : BoidsSpec):
    $ColorRect.rect_min_size = boids_spec.grid_size
    $GridMultiMesh.setup(boids_spec)
