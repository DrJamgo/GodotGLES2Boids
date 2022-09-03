extends Node2D

func _ready():
    $BoidsVisualMultiMesh.multimesh = $BoidsScene.get_multimesh()
    
    var shader := ($BoidsVisualMultiMesh.material as ShaderMaterial)
    shader.set_shader_param("state_texture", $BoidsScene.get_state_texture())
    shader.set_shader_param("world_size", $BoidsScene.boids_spec.world_size)
