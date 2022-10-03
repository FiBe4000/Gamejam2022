extends Node2D

const WS = preload("res://src/WorldChangeSystem.gd")


# There is Normal, Dark, Fire, Ice worlds
var worlds = {
  WS.World.NORMAL: $NormalLevel,
  WS.World.DARK: $NormalLevel,
  WS.World.FIRE: $NormalLevel,
  WS.World.ICE: $NormalLevel,
 }

var tilesets = {
  WS.World.NORMAL: "res://graphics/tilemaps/home_plane.tres",
  WS.World.DARK: "res://graphics/tilemaps/dark_plane_fixed_2.tres",
  WS.World.FIRE: "res://graphics/tilemaps/fire_plane.tres",
  WS.World.ICE: "res://graphics/tilemaps/fey_plane.tres",
 }
var activeWorld = WS.World.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
  _set_visibility()
  for child in $NormalLevel.get_children():
    (child as TileMap).scale.x = 3
    (child as TileMap).scale.y = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _set_visibility():
  # Loop through all the worlds and set their visibility
  for k in worlds.keys():
    if worlds[k]:
      if k == activeWorld:
      # Loop through all the subnodes and set them to visible
        for child in worlds[k].get_children():
          child.visible = true
          # Set the tile map
          if child.is_class("TileMap"):
            child.set_tileset(load(tilesets[k]))


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
