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


func do_movement():
  for mob in mobs:
    var behaviour = mob.get_mob_behaviour()
    
    if behaviour.has(Behaviour_Move.STATIC):
      continue
    
    var tar_pos = player.position
    var speed = mob.get_move_speed()
    var speed_sqr = pow(speed,2)
    var error = (tar_pos - mob.position) as Vector2
    var dist_sqr = error.length_squared()
    if behaviour.has(Behaviour_Move.INTERCEPT):
      var eta = dist_sqr / speed_sqr
      tar_pos = tar_pos + player.speed * eta
    
    var dir = Vector2()
    var vel = 0
    if behaviour.has(Behaviour_Move.KEEP_DISTANCE):
      var desired_dist = mob.get_desired_distance()
      dir = error
      if dist_sqr < pow(desired_dist,2):
        dir = -dir
      vel = dist_sqr
      if speed_sqr < dist_sqr:
        vel = speed
    
    if behaviour.has(Behaviour_Move.STRAFE):
      var strafe_dir = mob.get_strafe_dir()
      dir.rotated(PI/2 * strafe_dir)
    
    mob.move(dir, vel)


func do_shootment():
  pass


func _on_MobFactory_mob_spawn(mob):
  mobs += [mob]


func _on_MobFactory_mob_died(mob):
  mobs.remove(mobs.find(mob))
