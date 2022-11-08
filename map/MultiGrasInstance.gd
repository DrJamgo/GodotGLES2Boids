extends MultiMeshInstance

export(NodePath) var boids_instance
onready var _boids := get_node(boids_instance) as BoidsInstance

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
        
        var grid = _boids.boids_spec.world_to_grid(world + Vector2(0,tilemap.cell_size.y / 2.0)) / _boids.boids_spec.grid_size

        world_3d.x += rng.randi_range(-2, 2)
        world_3d.z += rng.randi_range(-8, 8)
        world_3d.y += rng.randi_range(-2, 2)
        var transform := Transform.IDENTITY
        transform = transform.rotated(Vector3(0,1,0), rng.randf_range(-PI*0.1, PI*0.1))
        transform.origin = world_3d

        mesh.set_instance_transform(index, transform)
        mesh.set_instance_custom_data(index, Color(UV.x, UV.y, grid.x, 1.0-grid.y))
        index += 1

func _ready():
    rng.randomize()
    for tilemap in get_tree().get_nodes_in_group("tilemap_3d"):
        _add_gras_instances(tilemap)
        tilemap.visible = false

func _process(delta):
    (material_override as ShaderMaterial).set_shader_param("dynamic_grid", _boids.dynamic_grid)
