tool
extends KinematicBody2D


export var speed = 500
export var bullet_speed = 10
export var rof = 2

var Bullet = preload("res://src/entities/Bullet.tscn")
var last_shot = 0
var look_dir = Vector2(1,0)


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func _physics_process(delta):
  if Engine.editor_hint:
    return
  
  var dir = Vector2()
  dir.x -= Input.get_action_strength("move_left")
  dir.x += Input.get_action_strength("move_right")
  dir.y -= Input.get_action_strength("move_up")
  dir.y += Input.get_action_strength("move_down")
  if dir.x != 0 or dir.y != 0:
    look_dir = dir
  
  var vel = speed * dir
  self.move_and_slide(vel)
  
  var cooldown = 1.0/rof
  last_shot += delta
  if Input.is_action_pressed("shoot") and last_shot >= cooldown:
    last_shot = 0
    shoot()


func _draw():
  var shape = self.get_node("CollisionShape2D")
  var pos = shape.transform.origin
  var dim = shape.shape.extents
  var col = Color(1, 0, 0, 1)
  draw_rect(Rect2(pos-dim, dim*2), col)


func shoot():
  var aim_dir = Vector2()
  aim_dir.x -= Input.get_action_strength("aim_left")
  aim_dir.x += Input.get_action_strength("aim_right")
  aim_dir.y -= Input.get_action_strength("aim_up")
  aim_dir.y += Input.get_action_strength("aim_down")
  if aim_dir.x == 0 and aim_dir.y == 0:
    aim_dir = look_dir
  aim_dir = aim_dir.normalized()
  
  var b = Bullet.instance()
  b.start(self.transform.origin, aim_dir, bullet_speed)
  get_parent().add_child(b)
