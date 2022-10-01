extends Node2D

const WS = preload("res://src/WorldSystem.gd")


# There is Normal, Dark, Fire, Ice worlds
var worlds = {
  WS.WORLD.NORMAL: $Normal,
  WS.WORLD.DARK: $Dark,
  WS.WORLD.FIRE: $Fire,
  WS.WORLD.ICE: $Ice,
  WS.WORLD.VOID: $Void,
 }
var activeWorld = WS.WORLD.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
   _set_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _set_visibility():
  # Loop through all the worlds and set their visibility
  for k in worlds.keys():
    if worlds[k]:
      if k == activeWorld:
        worlds[k].visible = true
      else:
        worlds[k].visible = false
      self._toggle_tilemap_collision(worlds[k])


# Take a tile map and set the collision layer to an unused layer if it is not visible
func _toggle_tilemap_collision(tileMap):
  if tileMap.visible:
    tileMap.collision_layer = 3
    tileMap.collision_mask  = 3
  else:
    tileMap.collision_layer = 0
    tileMap.collision_mask  = 0

func _input(event):
   # This event resets the world switch timer, and we manually trigger the world
   # switch here.
   if event.is_action_pressed("force_world_timeout"):
    self._on_WorldSystem_next_world_change(WS.WORLD.NORMAL)

#func _on_WorldSwitchTimer_timeout():
#  activeWorld = (activeWorld + 1) % worlds.size()
#  self._set_visibility()

func _on_WorldSystem_next_world_change(new_world):
  activeWorld = new_world
  _set_visibility()
