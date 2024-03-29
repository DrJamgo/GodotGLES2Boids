# MIT License
# Copyright (c) 2022 DrJamgo

extends Viewport

signal boids_count_changed(amount)

var _spec : BoidsSpec
var num_boids := 0 setget _set_num_boids, _get_num_boids

func _set_num_boids(num : int):
    num_boids = num
    $Cursor.offset.x = num
    
func _get_num_boids() -> int:
    return num_boids

onready var rng := RandomNumberGenerator.new()

func setup(spec : BoidsSpec, copy_texture : ViewportTexture, dynamic_grid : ViewportTexture):
    _spec = spec
    self.size = spec.state_size
    $BoidsProcesor.setup(spec, copy_texture, dynamic_grid)

func set_target(position : Vector2):
    $BoidsProcesor.set_target(position)

func set_static_grid(static_grid : Texture):
    $BoidsProcesor.set_static_grid(static_grid)

func add_boids_with_spread(position : Vector2, amount : int, spread : Vector2):
    
    var boids_to_add = min(_spec.boids_capacity - $Cursor.offset.x, amount)
    
    if boids_to_add > 0:
        var data := PoolByteArray()
        
        for i in range(0, boids_to_add):
            var pos = position + Vector2(rng.randf_range(-spread.x, spread.x),rng.randf_range(-spread.y, spread.y))
            pos.x = clamp(pos.x, 0.0, _spec.world_size.x)
            pos.y = clamp(pos.y, 0.0, _spec.world_size.y)
        
            var color_pos = _spec.world_to_rgba(pos)
            data.append(color_pos.r)
            data.append(color_pos.g)
            data.append(color_pos.b)
            data.append(color_pos.a)
            
        for i in range(0, boids_to_add):
            data.append(127)
            data.append(127)
            data.append(0)   # <- unused
            data.append(0) # <- unused
        
        var image = Image.new()
        image.create_from_data(boids_to_add, 2, false, Image.FORMAT_RGBA8, data)
        
        var tex = ImageTexture.new()
        tex.create_from_image(image, 0)
        yield(get_tree(), "idle_frame")
        
        $Cursor.texture = tex
        yield(get_tree(), "idle_frame")
        $Cursor.texture = null
        
        _set_num_boids(num_boids + boids_to_add)
        emit_signal("boids_count_changed", num_boids)
        
    else:
        push_error("No Boids added (" + str(_spec.boids_capacity) + ")")
        
    
    
