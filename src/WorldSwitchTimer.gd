extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _input(event):
  # Restart the timer on force world timeout
   if event.is_action_pressed("force_world_timeout"):
    self.stop()
    self.start(self.get_wait_time())
    
