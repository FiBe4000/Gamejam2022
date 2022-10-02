extends Node2D

const WS = preload("res://src/WorldChangeSystem.gd")


# There is Normal, Dark, Fire, Ice worlds
var worlds = {
  WS.World.NORMAL.name: $Normal,
  WS.World.DARK.name: $Dark,
  WS.World.FIRE.name: $Fire,
  WS.World.ICE.name: $Ice,
 }
var activeWorld = WS.World.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
   _set_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _set_visibility():
  # Loop through all the worlds and set their visibility
  for k in worlds.keys():
    var w = worlds[k]
    if worlds[k]:
      if k == activeWorld.name:
        w.visible = true
      else:
        w.visible = false
      self._toggle_tilemap_collision(w)


# Take a tile map and set the collision layer to an unused layer if it is not visible
func _toggle_tilemap_collision(tileMap):
  if tileMap.visible:
    tileMap.collision_layer = 3
    tileMap.collision_mask  = 3
  else:
    tileMap.collision_layer = 0
    tileMap.collision_mask  = 0

func _on_WorldChangeSystem_next_world_change(new_world):
  activeWorld = new_world
  _set_visibility()
