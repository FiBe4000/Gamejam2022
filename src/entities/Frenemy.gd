tool
extends KinematicBody2D

signal frenemy_death


export var hp = 1
var parent = 1


func body_enter(body):
  print("AAAH")


func _draw():
  var shape = self.get_node("CollisionShape2D")
  var pos = shape.transform.origin
  var dim = shape.shape.extents
  var col = Color(0, 0, 0, 1)
  draw_rect(Rect2(pos-dim, dim*2), col)


func take_damage(dmg):
  hp = hp - dmg
  if hp < 0:
    die()

func die():
  emit_signal("frenemy_death", self)
  #parent.remove(self)
  queue_free()
