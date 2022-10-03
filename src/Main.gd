extends Node

const change_period = PI / 20 # half turn / seconds

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
  var rot = change_period
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

