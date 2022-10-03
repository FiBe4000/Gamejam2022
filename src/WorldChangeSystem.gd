extends Node


signal world_discovery
signal next_world_change
signal new_world_alignment

const World = {
  NORMAL={name="NORMAL", col=Color(0, 1, 0, 1), texture=null, order=0},
  DARK  ={name="DARK",   col=Color(0, 0, 0, 1), texture=null, order=2},
  FIRE  ={name="FIRE",   col=Color(1, 0, 0, 1), texture=null, order=1},
  ICE   ={name="ICE",    col=Color(0, 1, 1, 1), texture=null, order=3},
 }
const NORTH = Vector2(1,0) # .angle() == 0

export var step_size = (PI/4)/4

var known_worlds = []
var cur_world = World.NORMAL
var next_world = World.NORMAL
var world_alignment = NORTH
var world_distance = 0


func _ready():
  add_world(World.NORMAL)
  add_world(World.DARK)
  add_world(World.ICE)
  add_world(World.FIRE)
  emit_signal("next_world_change", next_world)
  emit_signal("new_world_alignment", world_alignment)


func approach(world, ang_str = step_size):
  var ang_cur = fmod(world_alignment.angle() + 2*PI, 2*PI)
  var idx = known_worlds.find(world)
  var ang_tar = world_distance * idx
  var error = ang_tar - ang_cur
  var rot = clamp(error, -ang_str, ang_str)
  world_alignment = NORTH.rotated(ang_cur + rot)
  var new_world = get_aligned_world()
  if new_world != next_world:
    next_world = new_world
  emit_signal("new_world_alignment", world_alignment)

func get_aligned_world():
  var ang = world_alignment.angle()
  # Take the dot product of the world alignement and the world vectors
  # to find the closest world
  var best_world = World.NORMAL
  var best_dot = 0
  for i in len(known_worlds):
    var w = known_worlds[i]
    var w_ang = world_distance * i
    var w_dir = NORTH.rotated(w_ang)
    var dot = w_dir.dot(world_alignment)
    if dot > best_dot:
      best_dot = dot
      best_world = w
  return best_world

func add_world(world):
  var new_known = []
  var added = false
  for w in known_worlds:
    assert(w.order != world.order, "ERROR - two worlds with same 'order'")
    if world.order < w.order and not added:
      new_known += [world]
      added = true
    new_known += [w]
  if len(new_known) == len(known_worlds):
    new_known += [world]
  known_worlds = new_known
  world_distance = 2.0*PI / len(known_worlds)
  emit_signal("world_discovery", known_worlds)

func _input(event):
  # This event resets the world switch timer, and we manually trigger the world
  # switch here.
  if event.is_action_pressed("force_world_timeout"):
    # Rotate world alignment to clockwise next world
    var next_world_idx = (known_worlds.find(next_world) + 1) % len(known_worlds)
    approach(known_worlds[next_world_idx], 2*PI)
    _on_WorldSwitchTimer_timeout()

func _on_MobFactory_mob_died(mob):
  var world = World.NORMAL
  match(mob.get_mob_type()):
    "normal":
      world = World.NORMAL
    "dark":
      world = World.DARK
    "fire":
      world = World.FIRE
    "ice", "fey": # "fey" near homonym to "fire"? But although it was never used to set animation, the ice animations contains the word, so prolly that.
      world = World.ICE
  approach(world, mob.get_value()*PI)

func _on_WorldSwitchTimer_timeout():
  if cur_world != next_world:
    cur_world = next_world
    emit_signal("next_world_change", next_world)
