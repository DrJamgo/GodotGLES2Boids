extends Viewport

signal boids_added(amount)

var _spec : BoidsSpec

onready var rng := RandomNumberGenerator.new()

func setup(boids_spec : BoidsSpec):
    _spec = boids_spec
    $BoidsProcesor.setup(boids_spec)

func add_boid(position : Vector2, amount : int, spread : Vector2):
    
    var num_boids = min(_spec.boids_capacity - $Cursor.offset.x, amount)
    
    if num_boids > 0:
        var data : PoolByteArray
        var color_speed = _spec.world_to_rgba(_spec.world_size / 2.0)
        
        
        for i in range(0, num_boids):
            var pos = position + Vector2(rng.randf_range(-spread.x, spread.x),rng.randf_range(-spread.y, spread.y))
            pos.x = clamp(pos.x, 0.0, _spec.world_size.x)
            pos.y = clamp(pos.y, 0.0, _spec.world_size.y)
        
            var color_pos = _spec.world_to_rgba(pos)
            data.append(color_pos.r)
            data.append(color_pos.g)
            data.append(color_pos.b)
            data.append(color_pos.a)
            
        for i in range(0, num_boids):
            data.append(color_speed.r)
            data.append(color_speed.g)
            data.append(color_speed.b)
            data.append(color_speed.a)
        
        var image = Image.new()
        image.create_from_data(num_boids, 2, false, Image.FORMAT_RGBA8, data)
        
        var tex = ImageTexture.new()
        tex.create_from_image(image, 0)
        yield(get_tree(), "idle_frame")
        
        $Cursor.texture = tex
        yield(get_tree(), "idle_frame")
        $Cursor.texture = null
        $Cursor.offset.x += num_boids
    
        emit_signal("boids_added", amount)
    else:
        push_error("Boids capacity (" + str(_spec.boids_capacity) + ") exceded!")
    
