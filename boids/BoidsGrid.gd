extends Viewport

func setup(spec : BoidsSpec):
    $ColorRect.rect_min_size = spec.grid_size
    $GridMultiMesh.setup(spec)
