extends CanvasLayer

const WS = preload("res://src/WorldChangeSystem.gd")

var rain_enabled = {
  WS.World.NORMAL: false,
  WS.World.DARK: true,
  WS.World.FIRE: false,
  WS.World.ICE: true,
 }

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


func _on_WorldChangeSystem_next_world_change(new_world):
  $Weather.visible = rain_enabled[new_world]
