extends Node2D

var switchCount = 1


# Called when the node enters the scene tree for the first time.
func _ready():
  # NormalWorld2 is visible on even counts
  # NormalWorld is visible on odd counts
  _toggle_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _toggle_visibility():
  $NormalWorld.visible = switchCount % 2 == 1
  $NormalWorld2.visible = switchCount % 2 == 0
  
  # Change tile collision layer to an unused layer
  self._set_tile_collision_layer($NormalWorld)
  self._set_tile_collision_layer($NormalWorld2)
  
  
# Take a tile map and set the collision layer to an unused layer if it is not visible
func _set_tile_collision_layer(tileMap):
  if tileMap.visible:
    tileMap.collision_layer = 1
  else:
    tileMap.collision_layer = 2

func _on_WorldSwitchTimer_timeout():
  switchCount += 1
  _toggle_visibility()
