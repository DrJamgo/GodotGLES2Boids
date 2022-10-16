class_name AightFrameSprite3D
extends Sprite3D

export(float) var jumpiness = 1.0 / 25.0
export(float) var jumpfrequency = 1.0

onready var atlas := texture as AtlasTexture
onready var default_region := atlas.region
onready var default_offset := offset
var velocity : Vector2
var dist : float

func _process(delta):
    offset.x = 0
    if(velocity.length() > 1.0):
        var angle = atan2(velocity.y, velocity.x)
        var frame = fmod(round(((angle / PI + 1.0) / 2) * 8.0 + 4.0), 8.0) 
        
        var new_region = default_region
        new_region.position.x += frame * default_region.size.x
        atlas.region = new_region

        offset.y = default_offset.y + round(sin(dist * jumpfrequency) * 0.5 * min(velocity.length(), 50.0) * jumpiness)
        dist += min(velocity.length(), 50) * delta
    else:
        dist = 0.0

