extends KinematicBody2D

signal hit

export var speed = 0
export var direction = Vector2(1,0)
export var started = false

var damage = 0


# Called when the node enters the scene tree for the first time.
func _ready():
  $AnimatedSprite.playing = true
  show()


func _physics_process(delta):
  if started:
    var offset = speed * direction
    var collision = self.move_and_collide(delta*offset)
    if collision:
      impact()

func start(position, direction, speed):
    createAndShoot(position, direction, speed, 0, Vector2(0.3,0.3))

func createAndShoot(position, direction, speed, damage, scale):
  self.position = position
  self.direction = direction
  if direction.x == 0 and direction.y == 0:
    self.direction = Vector2(1,0)
  self.rotation_degrees = direction.angle()
  self.speed = speed
  self.damage = damage
  self.scale = scale
  
  started = true
  

func impact():
  queue_free()
