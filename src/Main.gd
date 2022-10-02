extends Node

var score


func _ready():
    randomize()
    new_game()

func _process(delta):
  if Input.is_action_pressed("exit_game"):
    exit_game()
  
func game_over():
    pass

func new_game():
    score = 0
    $Player.start($StartPosition.position)

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
  
