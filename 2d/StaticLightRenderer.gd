extends Node2D

var boids_spec : BoidsSpec

export(Texture) var texture

const list_of_food_tiles := ["Flower1", "Flower2", "Shroom1"]

var elapsed_time := 0.0

func _draw():
    for tilemap in get_tree().get_nodes_in_group("tilemap_tiles"):
        print(" - " + tilemap.name)
        var tileset : TileSet = tilemap.tile_set
        for tilename in list_of_food_tiles:
            var index_flowers = tileset.find_tile_by_name(tilename)
            
            for c in tilemap.get_used_cells_by_id(index_flowers):
                var coordinate := (c as Vector2)
                var world : Vector2 = tilemap.map_to_world(coordinate)
                var rect = Rect2(world * boids_spec.grid_resolution, tilemap.cell_size * boids_spec.grid_resolution)
                
                var scale = 4.0
                
                scale += 0.4 * sin((elapsed_time * 5.0) + coordinate.x + coordinate.y*14.0)
    
                rect.position -= rect.size * (scale - 1.0) / 2.0
                rect.size *= scale
                rect.position.y += 3
                draw_texture_rect(texture, rect, false)

func _process(delta):
    update()
    elapsed_time += delta
