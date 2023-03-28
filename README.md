# Godot GLES2 Boids

## Intro
This is a Boids algorithm imlementaiton for Godot Game Engine 3.x, using GLES2 features only.

## Base Principle
(Re)implementation of previous GPU accelerated Boids algorithm for Godot game engine. Again, using fragment shaders (due to lack of OpenCL or computer shader access) for general-purpose processing. <br>
It uses a double-buffered texture as strorage for all particle states to update and feedback as input next render cycle.<br>
See a video on Reddit [here](https://www.reddit.com/r/godot/comments/x4yb93/wip_working_on_gpu_boids_implementation_for_gles2/?utm_source=share&utm_medium=web2x&context=3)

## Constraints
These are the contraints for the project, due to exclusive use of GLES2

### No Compute shaders
The boids computation (= particles) is done on a fragment shader [BoidsShader.gdshader](https://github.com/DrJamgo/GodotGLES2Boids/blob/main/boids/BoidsShader.gdshader)

### No float textures as render target
This is not supported on all devices, thus the render target is always RGBA8888 output. Higher precision is needed for particle position though, thus the position is encoded in 16bit fixed point values. See [rgba_to_world](https://github.com/DrJamgo/GodotGLES2Boids/blob/main/boids/BoidsShader.gdshader#L26) and [world_to_rgba](https://github.com/DrJamgo/GodotGLES2Boids/blob/main/boids/BoidsShader.gdshader#L34)

