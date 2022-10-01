tool
extends Node2D

const WorldSystem = preload("res://src/WorldSystem.gd")

const WORLD = {
  NORMAL=Color(0, 1, 0, 1),
  DARK=Color(0, 0, 0, 1),
  ICE=Color(0, 1, 1, 1),
  FIRE=Color(1, 0, 0, 1),
  VOID=Color(0.5, 0.5, 0.6, 1)
}

export var radius = 50

var segment = PI/2
var offset = PI/4
var needle_thickness = PI/16

var alignment = Vector2()

func _draw():
  draw_base()
  draw_needle()

func draw_base():
  var pos = transform.origin
  var segments = [WORLD.NORMAL, WORLD.ICE, WORLD.DARK, WORLD.FIRE]
  var n_points = 8
  var n = 0
  for col in segments:
    var a = n*segment+offset
    n = n+1
    var points_arc = PoolVector2Array()
    points_arc.push_back(pos)
    for i in range(n_points + 1):
      points_arc.push_back(pos + Vector2(cos(a), -sin(a)) * radius)
      a = a + segment/n_points
    draw_polygon(points_arc, PoolColorArray([col]))
  draw_circle(pos, radius/3, WORLD.VOID)
  
func draw_needle():
  var pos = transform.origin
  var a = alignment.angle() - needle_thickness/2
  var points_arc = PoolVector2Array()
  points_arc.push_back(pos)
  var n_points = 4
  for i in range(n_points + 1):
    points_arc.push_back(pos + Vector2(cos(a), -sin(a)) * radius/1.1)
    a = a + needle_thickness/n_points
  draw_polygon(points_arc, PoolColorArray([Color(0.7,0.0,0.7, 1)]))


func _on_WorldSystem_new_world_alignment(new_alignment):
  alignment = new_alignment
  self.update()
