tool
extends Node2D

var Frenemy = preload("res://src/entities/Frenemy.tscn")

var has_spawn = false
var last_spawn = 0
export var spawn_delay = 1

func spawn():
  has_spawn = true
  last_spawn = 0
  var e = Frenemy.instance()
  e.transform.origin = self.transform.origin
  e.parent = self
  e.connect("frenemy_death", self, "remove")
  get_parent().add_child(e)

func remove(e):
  has_spawn = false

func _ready():
  #connect("frenemy_death", self, "remove")
  pass

func _physics_process(delta):
  if Engine.editor_hint:
    return
  if not has_spawn:
    last_spawn += delta
    if last_spawn >= spawn_delay:
      spawn()

func _draw():
  var pos = Vector2()
  var dim = Vector2(5,5)
  var col = Color(0, 0, 0, 0.5)
  draw_rect(Rect2(pos-dim, dim*2), col)
