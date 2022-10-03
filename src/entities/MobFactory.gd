extends Node

const Behaviours = preload("res://src/systems/EnemyAISystem.gd")

signal mob_spawn
signal mob_died

var MOB_MAX = 50
var last_spawn = 0
var spawn_delay = 1.0
var difficulty_scale = 1.0
var Mob = preload("res://src/entities/Mob.tscn")

enum Type {
  NORMAL,
  DARK,
  FIRE,
  FEY, # synonyms increases the chance for their typing
  MORN,
  AKITES_RASS_PROFESSOR,
 }

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func _physics_process(delta):
  var mobs = get_tree().get_nodes_in_group("mobs")
  last_spawn += delta
  if mobs.size() < MOB_MAX and last_spawn > spawn_delay * (1 + mobs.size()/5):
    var i = rand_range(0,len(Type.keys()))
    var type = Type.keys()[i].to_lower()
    spawn(type, [Behaviours.Behaviour_Move.KEEP_DISTANCE], [Behaviours.Behaviour_Shoot.AIM])

func spawn(type, behaviour_move, behaviour_shoot):
  var ply = $"../Player"
  var ply_pos = ply.position
  var mob_pos = new_mob_position()
  var mob = Mob.instance()
  mob.connect("shoot", $BulletFactory, "_on_shoot")
  self.add_child(mob)
  mob.init(ply_pos + mob_pos, type, behaviour_move, behaviour_shoot, difficulty_scale)
  mob.z_index = 4
  var col = mob.move_and_collide(-mob_pos, true, true, true)
  if col.collider != ply:
    # Unable to move to player, retry new position (next frame)
    mob.queue_free()
    #spawn(type, behaviour_move, behaviour_shoot, delta)
  else:
    last_spawn = 0
    emit_signal("mob_spawn", mob)
  #var pool = (mob.patrol as PoolVector2Array) # Testing patrol stuff, meant to be used only in scene-editor
  #pool.push_back(mob.position)
  #pool.push_back(mob.position + Vector2(150, 0))
  #mob.patrol = pool

func new_mob_position():
  var pos = Vector2(rand_range(-400, 400), rand_range(-400, 400))
  return pos

func despawn(mob):
  emit_signal("mob_died", mob)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
