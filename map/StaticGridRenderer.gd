extends Node2D

var boids_spec : BoidsSpec

func _draw():
    var obstacles : TileMap = get_node("../../TileMap/TileMap")
    
    for c in obstacles.get_used_cells():
        var coordinate := (c as Vector2)
        var world := obstacles.map_to_world(coordinate)
        var index = obstacles.get_cell(coordinate.x, coordinate.y)
        for shape_dict in obstacles.tile_set.tile_get_shapes(index):
            var convex_polygon = shape_dict["shape"] as ConvexPolygonShape2D
            if convex_polygon:
                var world_points : PoolVector2Array
                var colors : PoolColorArray
                for p in convex_polygon.points:
                    world_points.append((p + world) * boids_spec.grid_resolution)
                    colors.append(Color(0,0,1,0.5))
                draw_polygon(world_points, colors)
    print("draw_static_grid")
