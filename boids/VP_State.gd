extends Viewport

signal boid_added()

var _boids_spec : BoidsSpec

func setup(boids_spec : BoidsSpec):
    _boids_spec = boids_spec

func add_boid(position : Vector2):
    var color = _boids_spec.Vector2_to_RGBA(position)
    
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
    
