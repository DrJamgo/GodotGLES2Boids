extends Viewport

signal boid_added()

func add_boid(position : Vector2):
    
    var data : PoolByteArray
    data.append(position.x)
    data.append(position.y)
    data.append(0)
    data.append(127)
    
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
    
# Called when the node enters the scene tree for the first time.
func _ready():
    
    pass # Replace with function body.
