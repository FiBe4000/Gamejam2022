extends Node


signal next_world_change

const WORLD = {
  NORMAL=Vector2(0,1),
  DARK=Vector2(0,-1),
  ICE=Vector2(-1,0),
  FIRE=Vector2(1,0),
  VOID=Vector2()
 }

export var step_size = (PI/4)/4

var next_world = WORLD.NORMAL
var world_alignment = Vector2(0,1)


func _ready():
  pass # Replace with function body.


func approach(world):
  var error = world_alignment.angle_to(world)
  var sig = sign(error)
  var rot = min(abs(error), step_size)
  rot = sig * rot
  world_alignment = world_alignment.rotated(rot)
  var new_world = get_aligned_world()
  if new_world != next_world:
    emit_signal("next_world_change")

func get_aligned_world():
  if world_alignment.x == 0 and world_alignment.y == 0:
    return WORLD.VOID
  var ang = world_alignment.angle()
  var margin = PI/4
  if within(ang, WORLD.NORMAL, margin):
    return WORLD.NORMAL
  if within(ang, WORLD.DARK, margin):
    return WORLD.DARK
  if within(ang, WORLD.ICE, margin):
    return WORLD.ICE
  if within(ang, WORLD.FIRE, margin):
    return WORLD.FIRE

func within(ang, world, margin):
  var world_ang = world.angle()
  return ang == clamp(ang, world_ang-margin, world_ang+margin)


func _on_WorldSwitchTimer_timeout():
  approach(WORLD.DARK)
