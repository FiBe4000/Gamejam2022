extends TextureRect

const WS = preload("res://src/WorldChangeSystem.gd")

func _ready():
  # Set the shader uniforms for the dark world
  material.set_shader_param("darkness_level", 0.6);
  var viewport_size = get_viewport().size
  material.set_shader_param("aspect_ratio", viewport_size.x / viewport_size.y)
  
  var light_color = Vector3(1.0, 1.0, 0.0);
  material.set_shader_param("light_color", light_color)
  

func _get_light_color(world):
  # Set light color depending on the new world
  match world:
    WS.World.NORMAL:
      return Vector3(1.0, 1.0, 0.0);
    WS.World.DARK:
      return Vector3(1.0, 1.0, 0.0);
    WS.World.FIRE:
      return Vector3(1.0, 1.0, 0.0);
    WS.World.ICE:
      return Vector3(1.0, 1.0, 0.0);


func _on_WorldChangeSystem_next_world_change(new_world):
  # Set darkness level depending on the new world
  match new_world:
    WS.World.NORMAL:
      material.set_shader_param("darkness_level", 0.9)
    WS.World.DARK:
      material.set_shader_param("darkness_level", 0.5)
    WS.World.FIRE:
      material.set_shader_param("darkness_level", 0.9)
    WS.World.ICE:
      material.set_shader_param("darkness_level", 0.8)
  # Set light color depending on the new world
  material.set_shader_param("light_color", self._get_light_color(new_world))
    
