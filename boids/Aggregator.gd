# MIT License
# Copyright (c) 2022 DrJamgo

extends Viewport

func setup(_spec : BoidsSpec, particles : Texture):
    size = Vector2(4, _spec.state_size.y)
    
    var image := Image.new()
    image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    var texture := ImageTexture.new()
    texture.create_from_image(image, 0)
    $Texture.texture = texture
    
    ($Texture.material as ShaderMaterial).set_shader_param("particles_size", _spec.state_size)
    ($Texture.material as ShaderMaterial).set_shader_param("particles_tex", particles)
    
func _on_BoidsInstance_boids_count_changed(num_boids):
    ($Texture.material as ShaderMaterial).set_shader_param("num_particles", num_boids)
