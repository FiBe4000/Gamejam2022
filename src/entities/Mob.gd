extends KinematicBody2D

signal shoot(sourceType, position, direction, speed, damage, size)

export var hit_points = 100
var look_dir = Vector2(0,0)
var dir = Vector2(0,0)
var speed = 500
var bullet_speed = 600
var bullet_damage = 10
var type = "normal"
var behavior = "defensive"

var Bullet = preload("res://src/entities/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  set_type("normal")
  pass # Replace with function body.
  
func init(pos, type, behavior):
  position = pos
  self.type = type
  self.behavior = behavior
  set_type(self.type)

func _physics_process(delta):
  if dir.x != 0 or dir.y != 0:
    look_dir = dir
  
  var vel = dir * speed
  self.move_and_slide(vel)
  
  if vel.length() > 0:
    $AnimatedSprite.play()
  else:
    $AnimatedSprite.stop()
  
  if dir.x != 0:
    $AnimatedSprite.flip_v = false
    $AnimatedSprite.flip_h = dir.x > 0
  
  if Input.is_action_pressed("shoot"):
    shoot(Vector2(1,0))
    
func move(dir, speed):
  self.dir = dir
  self.speed = speed

func hit(damage):
  hit_points -= damage
  
  if hit_points <= 0:
    death()

func death():
  pass

func get_mob_type():
  return type

func get_mob_behavior():
  return behavior

func shoot(aim_dir):
  if aim_dir.x == 0 and aim_dir.y == 0:
    aim_dir = look_dir
  aim_dir = aim_dir.normalized()
  
  var b = Bullet.instance()
  b.start(self.transform.origin, aim_dir, bullet_speed)
  get_parent().add_child(b)
  emit_signal("shoot", "Mob", position, aim_dir, bullet_speed, bullet_damage, Vector2(0.5, 0.5))

func set_type(type):
  match (type):
    "normal":
      $AnimatedSprite.animation = "walk_normal"
      $NormalTypeCollisionShape2D.disabled = false
      $DarkTypeCollisionShape2D.disabled = true
      $FireTypeCollisionShape2D.disabled = true
      $IceTypeCollisionShape2D.disabled = true
    "dark":
      $AnimatedSprite.animation = "walk_dark"
      $NormalTypeCollisionShape2D.disabled = true
      $DarkTypeCollisionShape2D.disabled = false
      $FireTypeCollisionShape2D.disabled = true
      $IceTypeCollisionShape2D.disabled = true
    "fire":
      $AnimatedSprite.animation = "walk_fire"
      $NormalTypeCollisionShape2D.disabled = true
      $DarkTypeCollisionShape2D.disabled = true
      $FireTypeCollisionShape2D.disabled = false
      $IceTypeCollisionShape2D.disabled = true
    "ice":
      $AnimatedSprite.animation = "walk_ice"
      $NormalTypeCollisionShape2D.disabled = true
      $DarkTypeCollisionShape2D.disabled = true
      $FireTypeCollisionShape2D.disabled = true
      $IceTypeCollisionShape2D.disabled = false
      
