extends KinematicBody2D

var speed = 0
var direction = Vector2(1,0)
var started = false

var damage = 0


func _ready():
  $AnimatedSprite.playing = true
  show()


func _physics_process(delta):
  if started:
    var offset = speed * direction
    var collision = self.move_and_collide(delta*offset)
    if collision:
      handleCollision(collision)

func start(position, direction, speed):
    createAndShoot(position, direction, speed, 0, Vector2(0.3,0.3), 254)

func createAndShoot(position, direction, speed, damage, scale, collisionMask):
  hide()
  self.position = position
  self.direction = direction
  if direction.x == 0 and direction.y == 0:
    self.direction = Vector2(1,0)
  self.rotation = direction.angle() + PI
  self.speed = speed
  self.damage = damage
  self.scale = scale
  self.collision_layer = 0
  self.collision_mask = collisionMask
  started = true
  
func handleCollision(collision):
  var collider = collision.get_collider()
  if collider.has_method("hit"):
    collider.hit(damage)
    queue_free()
  elif $TimeToLive.get_time_left() > 1.0:
    $TimeToLive.stop()
    $TimeToLive.set_wait_time(1.0)
    $FlamingTail.process_material.initial_velocity = 100
    $TimeToLive.start()


func _on_TimeToLive_timeout():
  queue_free()
