extends Node

# standard mobs interface:
# [Behaviour_Move] get_mob_behaviour()
# int get_move_speed()
# Mob.World get_mob_type()
# int get_mob_value()


enum Behaviour_Move {
  STATIC, # No behaviours functionally equivalent, but static mobs should override other behaviours
  KEEP_DISTANCE, # get_desired_distance() == 0 functionally equivalent to "APPROACH"
  INTERCEPT, # Treats players projected position as position used for other behaviours
  STRAFE, # get_strafe_dir()
  PATROL, # incompatible with other behaviours; [Vector2] get_next_patrol(); advance_patrol()
 }
enum Behaviour_Shoot {
  FRIENDLY, # No behaviours functionally equivalent, but friendly mobs should override other behaviours
  AIM, # Targets player; get_aim_spread()
  INTERCEPT, # Treats players projected position as position used for other behaviours
  FORWARD, # get_aim_dir(); get_aim_spread(); mutually exclusive to AIM
 }


var player
var mobs = []


# Called when the node enters the scene tree for the first time.
func _ready():
  player = self.get_node("../Player")


func _physics_process(delta):
  do_movement(delta)


func do_movement(_delta):
  for mob in mobs:
    assert(mob.has_method("get_mob_behaviour"), "ERROR: Mob interface not fulfilled!")
    assert(mob.has_method("get_move_speed"), "ERROR: Mob interface not fulfilled!")
    
    var behaviour = mob.get_mob_behaviour()
    var speed = mob.get_move_speed()
    
    if behaviour.has(Behaviour_Move.STATIC):
      continue
    
    var speed_sqr = pow(speed,2)
    var dir = Vector2()
    var vel = 0
    
    if behaviour.has(Behaviour_Move.PATROL):
      assert(not behaviour.has(Behaviour_Move.INTERCEPT), "ERROR: PATROL incompatible with INTERCEPT!")
      assert(not behaviour.has(Behaviour_Move.KEEP_DISTANCE), "ERROR: PATROL incompatible with KEEP_DISTANCE!")
      assert(mob.has_method("get_next_patrol"), "ERROR: Mob interface not fulfilled!")
      assert(mob.has_method("advance_patrol"), "ERROR: Mob interface not fulfilled!")
      var tar_pos = mob.get_next_patrol()
      var error = (tar_pos - mob.position) as Vector2
      var dist = error.length()
      if dist < 5:
        mob.advance_patrol()
      #vel = dist
      #if speed < dist:
      #  vel = speed
      vel = speed
      dir = error
    else:
      var tar_pos = player.position
      var error = (tar_pos - mob.position) as Vector2
      var dist_sqr = error.length_squared()
      if behaviour.has(Behaviour_Move.INTERCEPT):
        var eta = dist_sqr / speed_sqr
        tar_pos = tar_pos + player.speed * eta
        error = (tar_pos - mob.position) as Vector2
      
      if behaviour.has(Behaviour_Move.KEEP_DISTANCE):
        assert(mob.has_method("get_desired_distance"), "ERROR: Mob interface not fulfilled!")
        var desired_dist = mob.get_desired_distance()
        tar_pos = tar_pos - error.normalized() * desired_dist
        
      error = (tar_pos - mob.position) as Vector2
      var dist = error.length()
      dir = error
      #vel = dist
      #if speed < dist:
      # vel = speed
      vel = speed
      
      if behaviour.has(Behaviour_Move.STRAFE):
        assert(mob.has_method("get_strafe_dir"), "ERROR: Mob interface not fulfilled!")
        var strafe_dir = mob.get_strafe_dir()
        dir = dir + dir.normalized().rotated(PI/2 * strafe_dir) * vel
    
    mob.move(dir.normalized(), vel)


func do_shootment():
  pass


func _on_MobFactory_mob_spawn(mob):
  mobs += [mob]


func _on_MobFactory_mob_died(mob):
  mobs.remove(mobs.find(mob))
