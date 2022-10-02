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
  # Take the dot product of the world alignement and the world vectors
  # to find the closest world
  var best_world = WORLD.NORMAL
  var best_dot = 0
  for w in WORLD.values():
    var dot = w.dot(world_alignment)
    if dot > best_dot:
      best_dot = dot
      best_world = w
  return best_world

func _input(event):
   # This event resets the world switch timer, and we manually trigger the world
   # switch here.
   if event.is_action_pressed("force_world_timeout"):
      # Rotate world alignment 90 degrees
      world_alignment = world_alignment.rotated(PI/2)
      approach(world_alignment)

func _on_WorldSwitchTimer_timeout():
  approach(WORLD.DARK)
