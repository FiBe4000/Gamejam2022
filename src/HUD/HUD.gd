extends CanvasLayer



func _ready():
  $ScoreNumber.visible = false
  $DeahtNotice.visible = false
  pass

func start(score):
  $ScoreNumber.text = str(ceil(score))
  $ScoreNumber.visible = true

func _process(delta):
  pass

func update_player_health(health):
  #$HealthNumber.text = str(ceil(health))
  pass

func _on_Player_death():
  $ScoreNumber.text = str(ceil(0))
  $DeahtNotice.visible = true
