extends Node


signal next_world_change
signal new_world_alignment

const WORLD = {
  NORMAL=Vector2(0,1),
  DARK=Vector2(0,-1),
  ICE=Vector2(-1,0),
  FIRE=Vector2(1,0),
 }

export var step_size = (PI/4)/4

var next_world = WORLD.NORMAL
var world_alignment = next_world


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
    next_world = new_world
    emit_signal("next_world_change", next_world)
  emit_signal("new_world_alignment", world_alignment)

func get_aligned_world():
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
  var tolerance = 0.00001
  var world_ang = world.angle()
  return ang == clamp(ang, world_ang-margin-tolerance, world_ang+margin+tolerance)


func _on_WorldSwitchTimer_timeout():
  approach(WORLD.DARK)
