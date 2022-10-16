extends Node2D

var boids_spec : BoidsSpec

func _draw_colision_shapes(tilemap : TileMap):
    print(" - " + tilemap.name)
    for c in tilemap.get_used_cells():
        var coordinate := (c as Vector2)
        var world : Vector2 = tilemap.map_to_world(coordinate)
        var index = tilemap.get_cell(coordinate.x, coordinate.y)
        for shape_dict in tilemap.tile_set.tile_get_shapes(index):
            var convex_polygon = shape_dict["shape"] as ConvexPolygonShape2D
            if convex_polygon:
                var world_points : PoolVector2Array
                var colors : PoolColorArray
                for p in convex_polygon.points:
                    world_points.append((p + world) * boids_spec.grid_resolution)
                    colors.append(Color(0,0,1,0.5))
                draw_polygon(world_points, colors)

func _draw_food_tiles(tilemap : TileMap, color : Color):
    print(" - " + tilemap.name)
    var tileset : TileSet = tilemap.tile_set
    var index_flowers = tileset.find_tile_by_name("Flowers")
    
    for c in tilemap.get_used_cells_by_id(index_flowers):
        var coordinate := (c as Vector2)
        var world : Vector2 = tilemap.map_to_world(coordinate)
        var rect = Rect2(world * boids_spec.grid_resolution, tilemap.cell_size * boids_spec.grid_resolution) 
        draw_rect(rect, Color(0,1,0,0.3))

func _draw():
    print("draw tilemap_collision")
    for tilemap in get_tree().get_nodes_in_group("tilemap_collision"):
        _draw_colision_shapes(tilemap)
    print("draw tilemap_tiles")
    for tilemap in get_tree().get_nodes_in_group("tilemap_tiles"):
        _draw_food_tiles(tilemap, Color(0,0,1,0.5))
    
