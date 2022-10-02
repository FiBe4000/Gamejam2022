extends KinematicBody2D

signal shoot(sourceType, position, direction, speed, damage, scale)

export var speed = 200
export var bullet_speed = 300
export var rof = 2
export var bullet_spread = 0.1

var Bullet = preload("res://src/entities/Bullet.tscn")
var last_shot = 0
var look_dir = Vector2(1,0)


# Called when the node enters the scene tree for the first time.
func _ready():
  pass

func _physics_process(delta):
  movement()
  
  var cooldown = 1.0/rof
  last_shot += delta
  if Input.is_action_pressed("shoot") and last_shot >= cooldown:
    last_shot = 0
    shoot()

func movement():
  var dir = Vector2()
  dir.x -= Input.get_action_strength("move_left")
  dir.x += Input.get_action_strength("move_right")
  dir.y -= Input.get_action_strength("move_up")
  dir.y += Input.get_action_strength("move_down")
  if dir.x != 0 or dir.y != 0:
    look_dir = dir
  
  var vel = speed * dir
  self.move_and_slide(vel)
  
  if vel.length() > 0:
    $AnimatedSprite.play()
  else:
    $AnimatedSprite.stop()
  
  if dir.x != 0:
    $AnimatedSprite.animation = "walk"
    $AnimatedSprite.flip_v = false
    # See the note below about boolean assignment.
    $AnimatedSprite.flip_h = dir.x < 0
      
func _on_Player_body_entered(body):
  emit_signal("hit")
  
func hit(damage):
  pass
      
func start(pos):
  self.position = pos
  show()
  $CollisionShape2D.disabled = false

func shoot():
  var aim_dir = Vector2()
  aim_dir.x -= Input.get_action_strength("aim_left")
  aim_dir.x += Input.get_action_strength("aim_right")
  aim_dir.y -= Input.get_action_strength("aim_up")
  aim_dir.y += Input.get_action_strength("aim_down")
  if aim_dir.x == 0 and aim_dir.y == 0:
    aim_dir = look_dir
  aim_dir = aim_dir.normalized()
  
  # Get aim direction from player to mouse, if mouse is down.
  if(Input.is_mouse_button_pressed(BUTTON_LEFT)):
    var mouse_pos = get_global_mouse_position()
    var player_pos = get_global_position()
    aim_dir = (mouse_pos - player_pos).normalized()
  
  # Add some uncertainty to the aim.
  aim_dir += Vector2(rand_range(-bullet_spread, bullet_spread), rand_range(-bullet_spread, bullet_spread))

  emit_signal("shoot", "Player", self.position, aim_dir, bullet_speed, 10, Vector2(0.5, 0.5))
