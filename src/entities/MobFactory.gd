extends Node

signal mob_died

var MOB_MAX = 10
var Mob = preload("res://src/entities/Mob.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func _physics_process(delta):
  var mobs = get_tree().get_nodes_in_group("mobs")
  if mobs.size() < MOB_MAX:
    spawn("normal", "defensive")

func spawn(type, behavior):
  var mob_pos = new_mob_position()
  var mob = Mob.instance()
  get_parent().add_child(mob)
  mob.init(mob_pos, type, behavior)
  
  # Temp, remove when AI is implemented
  mob.move(Vector2(1,0), 40)

func new_mob_position():
  var pos = Vector2(rand_range(100, 400), rand_range(100, 400))
  return pos
  
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
