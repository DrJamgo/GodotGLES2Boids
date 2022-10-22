extends CollisionShape2D

export(NodePath) var boids_instance
var all_boids_inside := false
signal boids_inside_goal(all_inside)
var _finish_delay := 0.0

var rect : Rect2

func _draw():
    #draw_rect(rect, Color(1,1,1,0.3), false, 1.0)
    draw_arc(Vector2(0,0), 16.0, -PI, -PI + 2.0 * PI * _finish_delay, 32, Color(1,1,1,0.75), 4.0)

func _physics_process(delta):
    var boids := (get_node(boids_instance) as BoidsInstance)
    var boids_rect = boids.boids_aabb
    rect = Rect2(-shape.extents.x, -shape.extents.y, shape.extents.x * 2, shape.extents.y * 2)
    boids_rect.position = to_local(boids_rect.position)
    var all_inside = rect.encloses(boids_rect)
    
    if all_boids_inside != all_inside:
        all_boids_inside = all_inside
        emit_signal("boids_inside_goal", all_inside)
        update()
        
        if all_boids_inside:
            shape.extents *= 1.25
        else:
            shape.extents /= 1.25
        
    if all_boids_inside and $CPUParticles2D.visible:
        _finish_delay += delta / 2.0
        _finish_delay = clamp(_finish_delay, 0.0, 1.0)
        update()
    else:
        _finish_delay = 0.0
    
    #$ExitIcon.visible = all_boids_inside
    $CPUParticles2D.visible = (boids.fullnes_avg == 1.0)
