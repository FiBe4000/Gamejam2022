tool
extends Node2D


export var radius = 50

var needle_thickness = PI/16

var known_worlds = []
var alignment = Vector2()

func _ready():
  update()

func _draw():
  if len(known_worlds) != 0:
    draw_base()
    draw_needle()

func draw_base():
  var pos = transform.origin
  var world_slice = 2.0*PI / len(known_worlds)
  var slice_offset = world_slice/2
  var n_points = 8
  var n = 0
  for w in known_worlds:
    var col = w.col
    var a = n*world_slice - slice_offset
    n += 1
    var points_arc = PoolVector2Array()
    points_arc.push_back(pos)
    for i in range(n_points + 1):
      points_arc.push_back(pos + Vector2(sin(a), -cos(a)) * radius) # (1,0) = NORTH, rotate clockwise
      a = a + world_slice/n_points
    draw_polygon(points_arc, PoolColorArray([col]))
#  draw_circle(pos, radius/3, WORLD.VOID)

func draw_needle():
  var pos = transform.origin
  var a = alignment.angle() - needle_thickness/2
  var points_arc = PoolVector2Array()
  points_arc.push_back(pos)
  var n_points = 4
  for i in range(n_points + 1):
    points_arc.push_back(pos + Vector2(sin(a), -cos(a)) * radius/1.1) # (1,0) = NORTH, rotate clockwise
    a = a + needle_thickness/n_points
  draw_polygon(points_arc, PoolColorArray([Color(0.7,0.0,0.7, 1)]))


func _on_WorldChangeSystem_new_world_alignment(new_alignment):
  alignment = new_alignment
  self.update()


func _on_WorldChangeSystem_world_discovery(worlds):
  known_worlds = worlds
