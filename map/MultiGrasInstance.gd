extends MultiMeshInstance

var rng := RandomNumberGenerator.new()

func _add_gras_instances(tilemap : TileMap):
    var mesh := multimesh
    var tileset = tilemap.tile_set
    var tiles = tilemap.get_used_cells()
    var index := mesh.instance_count
    mesh.instance_count += tiles.size()
    for c in tiles:
        var index_gras = tilemap.get_cell(c.x, c.y)
        var rect = tileset.tile_get_region(index_gras)
        var UV = rect.position / tileset.tile_get_texture(index_gras).get_size()
        
        var coordinate := (c as Vector2)
        var world : Vector2 = tilemap.map_to_world(coordinate) + tilemap.cell_size / 2.0
        var world_3d : Vector3 = Vector3(world.x, 0, world.y)

        world_3d.x += rng.randi_range(-3, 3)
        world_3d.z += rng.randi_range(-6, 6)
        world_3d.y += rng.randi_range(-2, 2)
        var transform := Transform.IDENTITY
        transform = transform.rotated(Vector3(0,1,0), rng.randf_range(-PI*0.1, PI*0.1))
        transform.origin = world_3d

        mesh.set_instance_transform(index, transform)
        mesh.set_instance_custom_data(index, Color(UV.x, UV.y, 0, 0))
        index += 1

func _ready():
    rng.randomize()
    for tilemap in get_tree().get_nodes_in_group("tilemap_3d"):
        _add_gras_instances(tilemap)
        tilemap.visible = false
