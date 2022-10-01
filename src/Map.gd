extends Node2D

var switchCount = 1
# There is Normal, Dark, Fire, Ice worlds
var worlds = [$Normal, $Dark, $Fire, $Ice]
var activeWorld = 0

# Called when the node enters the scene tree for the first time.
func _ready():
   _set_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _set_visibility():
  # Loop through all the worlds and set their visibility
  for i in range(0, worlds.size()):
    if i == activeWorld:
      worlds[i].visible = true
    else:
      worlds[i].visible = false
    self._toggle_tilemap_collision(worlds[i])

  
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
    self._on_WorldSwitchTimer_timeout()

func _on_WorldSwitchTimer_timeout():
  activeWorld = (activeWorld + 1) % worlds.size()
  self._set_visibility()
