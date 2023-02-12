extends Node2D

var boids_spec : BoidsSpec

const colision_color = Color(0,0,1,1)
const food_color = Color(0,1,0,0.3)

func _draw_colision_shapes(tilemap : TileMap):
    print(" - " + tilemap.name)
    for c in tilemap.get_used_cells():
        var coordinate := (c as Vector2)
        var world : Vector2 = tilemap.map_to_world(coordinate)
        var index = tilemap.get_cell(coordinate.x, coordinate.y)
        var mode := tilemap.tile_set.tile_get_tile_mode(index)
        var shapes = tilemap.tile_set.tile_get_shapes(index)
        if shapes.size() > 0:
            # >> If not a SINGLE_TILE filter out the shapes by autotile_coord
            match mode:
                TileSet.AUTO_TILE:
                    var filtered_shapes = []
                    var autotile_coord = tilemap.get_cell_autotile_coord(coordinate.x, coordinate.y) 
                    for shape_dict in shapes:
                        if shape_dict["autotile_coord"] == autotile_coord:
                            filtered_shapes.append(shape_dict)
                    shapes = filtered_shapes
                TileSet.ATLAS_TILE:
                    print("ATLAS_TILE")
                    print(coordinate)
                    print(index)
                    print(shapes)
                    pass
                _:
                    print("SINGLE_TILE")
                    print(coordinate)
                    print(index)
                    print(shapes)
                
            for shape_dict in shapes:
                var convex_polygon = shape_dict["shape"] as ConvexPolygonShape2D
                if convex_polygon:
                    var world_points : PoolVector2Array
                    var colors : PoolColorArray
                    for p in convex_polygon.points:
                        world_points.append((p + world) * boids_spec.grid_resolution)
                        colors.append(colision_color)
                    draw_polygon(world_points, colors)

const list_of_food_tiles := ["Flower1", "Flower2", "Shroom1"]

func _draw_food_tiles(tilemap : TileMap, color : Color):
    print(" - " + tilemap.name)
    var tileset : TileSet = tilemap.tile_set
    for tilename in list_of_food_tiles:
        var index_flowers = tileset.find_tile_by_name(tilename)
        
        for c in tilemap.get_used_cells_by_id(index_flowers):
            var coordinate := (c as Vector2)
            var world : Vector2 = tilemap.map_to_world(coordinate)
            var rect = Rect2(world * boids_spec.grid_resolution, tilemap.cell_size * boids_spec.grid_resolution)
            rect.position.y += 3
            draw_rect(rect, food_color)

const outline_width = 2.0

func _draw_outline(tilemap : TileMap):
    var rect = tilemap.get_used_rect()
    rect.position = tilemap.map_to_world(rect.position)* boids_spec.grid_resolution
    rect.size = tilemap.map_to_world(rect.size) * boids_spec.grid_resolution
    rect.position += Vector2.ONE * outline_width / 2.0
    rect.size -= Vector2.ONE * outline_width
    
    draw_rect(rect, colision_color, false, outline_width, false)

func _draw():
    print("draw tilemap_collision")
    for tilemap in get_tree().get_nodes_in_group("tilemap_collision"):
        _draw_colision_shapes(tilemap)
        #_draw_outline(tilemap)
    print("draw tilemap_tiles")
    for tilemap in get_tree().get_nodes_in_group("tilemap_tiles"):
        _draw_food_tiles(tilemap, Color(0,0,1,0.5))
    
