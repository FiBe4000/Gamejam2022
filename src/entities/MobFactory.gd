extends Node

const Behaviours = preload("res://src/systems/EnemyAISystem.gd")

signal mob_spawn
signal mob_died

var MOB_MAX = 10
var Mob = preload("res://src/entities/Mob.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func _physics_process(delta):
  var mobs = get_tree().get_nodes_in_group("mobs")
  if mobs.size() < MOB_MAX:
    spawn("fey", [Behaviours.Behaviour_Move.PATROL], [Behaviours.Behaviour_Shoot.FORWARD])

func spawn(type, behaviour_move, behaviour_shoot):
  var mob_pos = new_mob_position()
  var mob = Mob.instance()
  self.add_child(mob)
  mob.init(mob_pos, type, behaviour_move, behaviour_shoot)
  var pool = (mob.patrol as PoolVector2Array)
  pool.push_back(mob.position)
  pool.push_back(mob.position + Vector2(150, 0))
  mob.patrol = pool
  emit_signal("mob_spawn", mob)

func new_mob_position():
  var pos = Vector2(rand_range(100, 400), rand_range(100, 400))
  return pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
