extends CanvasLayer



func _ready():
  $HealthNumber.visible = false
  $DeahtNotice.visible = false
  pass

func start(health):
  $HealthNumber.text = str(ceil(health))
  $HealthNumber.visible = true

func _process(delta):
  pass

func update_player_health(health):
  $HealthNumber.text = str(ceil(health))

func _on_Player_death():
  $HealthNumber.text = str(ceil(0))
  $DeahtNotice.visible = true
