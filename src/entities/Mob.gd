extends KinematicBody2D

const Behaviours = preload("res://src/systems/EnemyAISystem.gd")

signal shoot(sourceType, position, direction, speed, damage, size)

export var hit_points = 100
export var patrol = PoolVector2Array()

var next_patrol = 0
var look_dir = Vector2(0,0)
var dir = Vector2(0,0)
var move_speed = 40
var strafe_dir = 1
var speed = 40
var bullet_speed = 600
var bullet_spread = PI/4
var bullet_damage = 10
var type = "normal"
var behavior_move = [Behaviours.Behaviour_Move.STATIC]
var behavior_shoot = [Behaviours.Behaviour_Shoot.FRIENDLY]
var desired_distance = 100

var Bullet = preload("res://src/entities/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  set_type("normal")
  pass # Replace with function body.
  
func init(pos, type, behavior_move, behavior_shoot):
  position = pos
  self.type = type
  self.behavior_move = behavior_move
  self.behavior_shoot = behavior_shoot
  set_type(self.type)

func _physics_process(delta):
  if dir.x != 0 or dir.y != 0:
    look_dir = dir
  
  var vel = dir * speed
  self.move_and_slide(vel)
  select_animation(vel)
  
  #if Input.is_action_pressed("shoot"):
  #  shoot(Vector2(1,0))

func select_animation(vel):
  if vel.length() > 0:
    match (type):
      "normal":
        $AnimatedSprite.animation = "walk_normal"
      "dark":
        $AnimatedSprite.animation = "walk_dark"
      "fire":
        $AnimatedSprite.animation = "walk_fire"
      "ice":
        $AnimatedSprite.animation = "walk_ice"
    $AnimatedSprite.play()
  else:
    match (type):
      "normal":
        $AnimatedSprite.animation = "idle_normal"
      "dark":
        $AnimatedSprite.animation = "idle_dark"
      "fire":
        $AnimatedSprite.animation = "idle_fire"
      "ice":
        $AnimatedSprite.animation = "idle_ice"
    $AnimatedSprite.play()
  
  if dir.x != 0:
    $AnimatedSprite.flip_v = false
    $AnimatedSprite.flip_h = dir.x > 0

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

func get_mob_move_behaviour():
  return behavior_move
  
func get_mob_shoot_behaviour():
  return behavior_shoot

func get_desired_distance():
  return desired_distance

func get_move_speed():
  return move_speed
  
func get_shoot_speed():
  return bullet_speed
  
func get_shoot_spread():
  return bullet_spread

func get_strafe_dir():
  return strafe_dir

func get_next_patrol():
  if patrol.size() > 0:
    return patrol[next_patrol]
  return self.position

func advance_patrol():
  next_patrol = (next_patrol + 1) % len(patrol)

func shoot(aim_dir):
  if aim_dir.x == 0 and aim_dir.y == 0:
    aim_dir = look_dir
  aim_dir = aim_dir.normalized()
  
  var b = Bullet.instance()
  b.start(self.transform.origin, aim_dir, bullet_speed)
  get_parent().add_child(b)
  
  match (type):
    "normal":
      $AnimatedSprite.animation = "attack_normal"
    "dark":
      $AnimatedSprite.animation = "attack_dark"
    "fire":
      $AnimatedSprite.animation = "attack_fire"
    "ice":
      $AnimatedSprite.animation = "attack_ice"
  $AnimatedSprite.play()
  
  emit_signal("shoot", "Mob", position, aim_dir, bullet_speed, bullet_damage, Vector2(0.5, 0.5))

func set_type(type):
  self.type = type
  match (self.type):
    "normal":
      disable_collision()
      $NormalTypeCollisionShape2D.disabled = false
    "dark":
      disable_collision()
      $DarkTypeCollisionShape2D.disabled = false
    "fire":
      disable_collision()
      $FireTypeCollisionShape2D.disabled = false
    "ice":
      disable_collision()
      $IceTypeCollisionShape2D.disabled = false
      
func disable_collision():
      $NormalTypeCollisionShape2D.disabled = true
      $DarkTypeCollisionShape2D.disabled = true
      $FireTypeCollisionShape2D.disabled = true
      $IceTypeCollisionShape2D.disabled = true
  
