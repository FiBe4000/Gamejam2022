extends Node

const change_period = PI / 100 # half turn / seconds
const variability_period = PI / (1 * 1000) # half turn / (seconds * milliseconds)
const variability_strength = 0.1
const variability_friction_str = 10

var variability_vel = 0
var lowest = variability_vel
var highest = variability_vel

var score

func _ready():
  randomize()
  new_game()

func _process(delta):
  if Input.is_action_pressed("exit_game"):
    exit_game()
  update_health_bar()
  update_world_alignment(delta)

func update_health_bar():
  $HUD_Scene.update_player_health(($Player.get_health()))

func update_world_alignment(delta):
  var variability_acc = 1*sin(float(OS.get_ticks_msec()) * variability_period) + 20*rand_range(-1.0,1.0)
  variability_vel += variability_acc * delta
  var variability_friction = 1 + variability_friction_str * abs(variability_vel) * delta
  variability_vel /= variability_friction
  #variability_vel = sign(variability_vel) * sqrt(abs(variability_vel))
  var rot = change_period + variability_vel*variability_strength
  $WorldChangeSystem.rotate(rot * delta, -1)

func game_over():
  pass

func new_game():
  score = 0
  $Player.start($StartPosition.position)
  $HUD_Scene.start($Player.get_health())

func exit_game():
  get_tree().quit()

func _on_ScoreTimer_timeout():
  score += 1
  $HUD.update_score(score)

func _on_StartTimer_timeout():
  $MobTimer.start()
  $ScoreTimer.start()


func _on_PlayerScene_hit():
  game_over()


func _on_HUD_start_game():
  new_game()

