extends KinematicBody2D


const Frenemy = preload("res://src/entities/Frenemy.gd")

export var dmg = 2
export var speed = 0
export var dir = Vector2(1,0)
export var started = false


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


func _physics_process(delta):
  if started:
    var offset = speed * dir
    var collision = self.move_and_collide(delta*offset)
    if collision:
      impact((collision as KinematicCollision2D).get_collider())


func _draw():
  var shape = self.get_node("CollisionShape2D")
  var pos = shape.transform.origin
  var rad = shape.shape.radius
  var col = Color(0, 1, 0, 1)
  draw_circle(pos, rad, col)


func start(pos, direction, speed = self.speed):
    position = pos
    dir = direction
    if dir.x == 0 and dir.y == 0:
      dir = Vector2(1,0)
    self.speed = speed
    #rotation = direction
    #velocity = Vector2(speed, 0).rotated(rotation)
    started = true


func impact(body : KinematicBody2D):
  if body.has_method("take_damage"):
    body.take_damage(dmg)
  queue_free()
