extends KinematicBody2D

const Behaviours = preload("res://src/systems/EnemyAISystem.gd")

signal shoot(sourceType, position, direction, speed, damage, size)
signal health_changed(health_percent)

export var max_health = 100.0
export var patrol = PoolVector2Array()
export var value = 0.2 # 1 == 100% of PI (rotate to opposite side)

var hit_points = max_health
var next_patrol = 0
var look_dir = Vector2(0,0)
var dir = Vector2(0,0)
var move_speed = 40.0
var strafe_dir = 1
var speed = 40
var bullet_speed = 200.0
var bullet_spread = PI/16
var bullet_damage = 10.0
var type = "normal"
var behavior_move = [Behaviours.Behaviour_Move.STATIC]
var behavior_shoot = [Behaviours.Behaviour_Shoot.FRIENDLY]
var desired_distance = 100
var rof = 0.5
var last_shot = 0
var shoot_cooldown = 0
var shooting = false

var Bullet = preload("res://src/entities/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  set_type("normal")
  pass # Replace with function body.
  
func init(pos, type, behavior_move, behavior_shoot, difficulty_scale):
  position = pos
  self.type = type
  self.behavior_move = behavior_move
  self.behavior_shoot = behavior_shoot
  set_type(self.type)
  scale(difficulty_scale)

func scale(difficulty_scale):
  max_health *= difficulty_scale
  hit_points *= difficulty_scale
  move_speed *= 1 + difficulty_scale / 2 - 1.0 / 2 # scale slower
  bullet_speed *= 1 + difficulty_scale / 2 - 1.0 / 2
  bullet_damage *= difficulty_scale
  rof *= 1 + difficulty_scale / 3 - 1.0 / 3
  bullet_spread *= 1 + difficulty_scale / 10 - 1.0 / 10# higher rof supports higher spread -> harder to dodge
  bullet_damage *= difficulty_scale

func _physics_process(delta):
  if dir.x != 0 or dir.y != 0:
    look_dir = dir
  
  if not shooting:
    var vel = dir * speed
    self.move_and_slide(vel)
    select_animation(vel)
  
  last_shot += delta
  
  #if Input.is_action_pressed("shoot"):
  #  shoot(Vector2(1,0))


func map_type_to_sprite(type):
  match (type):
    "normal":
      return "normal"
    "dark":
      return "dark"
    "fire":
      return "fire"
    "ice", "fey":
      return "fey"
    "morn":
      return "morn"
    "akites_rass_professor":
      return "akites_rass_professor"


func select_animation(vel):
  if not ($AnimatedSprite as AnimatedSprite).is_playing():
    return
  
  if vel.length() > 0:
    $AnimatedSprite.animation = "walk_"+map_type_to_sprite(type)
    $AnimatedSprite.play()
  else:
    $AnimatedSprite.animation = "idle_"+map_type_to_sprite(type)
    $AnimatedSprite.play()
  
  if dir.x != 0:
    $AnimatedSprite.flip_v = false
    $AnimatedSprite.flip_h = dir.x > 0

func move(dir, speed):
  self.dir = dir
  self.speed = speed

func hit(damage):
  set_health( max(0, hit_points - damage) )
  if hit_points <= 0:
    death()

func death():
  get_parent().despawn(self)
  queue_free()

func set_health(health: float):
  self.hit_points = health
  emit_signal("health_changed", get_health_percent())

func get_health_percent() -> float:
  return float(hit_points)/max_health

func get_mob_type():
  return type
  
func get_value():
  return value

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
  
  shoot_cooldown = 1.0/rof
  if last_shot >= shoot_cooldown:
    last_shot = 0
    shooting == true
    $AnimatedSprite.play("attack_"+map_type_to_sprite(type))
    var shooter_type = "Mob"
    var bullet_scale = Vector2(0.2, 0.2)
    if get_mob_type() == "morn":
      shooter_type = "morn"
      bullet_scale = Vector2(3.3, 3.3)
    emit_signal("shoot", shooter_type, position, aim_dir, bullet_speed, bullet_damage, bullet_scale)

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
    "fey":
      disable_collision()
      $FeyTypeCollisionShape2D.disabled = false
    "morn":
      disable_collision()
      self.scale = Vector2(3.3, 3.3)
      $MornCollisionShape2D.disabled = false
    "akites_rass_professor":
      disable_collision()
      self.scale = Vector2(3.3, 3.3)
      $AkitesRassProfessorCollisionShape2D.disabled = false

func disable_collision():
  $NormalTypeCollisionShape2D.disabled = true
  $DarkTypeCollisionShape2D.disabled = true
  $FireTypeCollisionShape2D.disabled = true
  $FeyTypeCollisionShape2D.disabled = true
  $MornCollisionShape2D.disabled = true
  $AkitesRassProfessorCollisionShape2D.disabled = true


func _on_AnimatedSprite_animation_finished():
  if $AnimatedSprite.animation != "walk_"+map_type_to_sprite(type):
    shooting = false
  pass # Replace with function body.
