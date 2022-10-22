extends Spatial

export(NodePath) var camera

func _process(delta):
    var camera_2d = get_node(camera) as Camera2D
    if camera_2d:
        $Camera.transform.origin.x = round(camera_2d.get_camera_screen_center().x)
        $Camera.transform.origin.z = round(camera_2d.get_camera_screen_center().y)
