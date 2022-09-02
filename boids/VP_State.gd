extends Viewport

signal boid_added()

var _spec : BoidsSpec

func setup(boids_spec : BoidsSpec):
    _spec = boids_spec

func add_boid(position : Vector2):
    
    if $Cursor.offset.x < _spec.boids_capacity:
        print(position)
        position.x = clamp(position.x, 0.0, _spec.world_size.x)
        position.y = clamp(position.y, 0.0, _spec.world_size.y)
        
        var color = _spec.world_to_rgba(position)
        
        var data : PoolByteArray
        data.append(color.r)
        data.append(color.g)
        data.append(color.b)
        data.append(color.a)
        
        var image = Image.new()
        image.create_from_data(1, 1, false, Image.FORMAT_RGBA8, data)
        
        var tex = ImageTexture.new()
        tex.create_from_image(image, 0)
        yield(get_tree(), "idle_frame")
        
        $Cursor.texture = tex
        yield(get_tree(), "idle_frame")
        $Cursor.texture = null
        $Cursor.offset.x += 1
    
        emit_signal("boid_added")
    else:
        push_error("Boids capacity (" + str(_spec.boids_capacity) + ") exceded!")
    
