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
    tileMap.collision_layer = 1
  else:
    tileMap.collision_layer = 2

func _on_WorldSwitchTimer_timeout():
  self.activeWorld = (self.activeWorld + 1) % self.worlds.size()
  self._set_visibility()
