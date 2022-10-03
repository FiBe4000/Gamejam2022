extends TextureRect


func _ready():
  # Set the shader uniforms for the dark world
  material.set_shader_param("darkness_level", 0.6);
  var viewport_size = get_viewport().size
  material.set_shader_param("aspect_ratio", viewport_size.x / viewport_size.y)
  
  var light_color = Vector3(1.0, 1.0, 0.0);
  material.set_shader_param("light_color", light_color)
