extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentTime 
var maxTime
var synced = false

# Called when the node enters the scene tree for the first time.
func _ready():
  self.currentTime = 0.0
  self.maxTime = 10.0
  self.value = 0.0
  self.max_value = 100.0
  self.min_value = 0.0
  self.fill_mode = 4
  self.radial_initial_angle = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  # Update the progress bar to be a percantage of the time remaining to the next 10 second mark
  self.currentTime += delta
  if self.currentTime >= self.maxTime:
    self.currentTime = 0.0
  self.value = (self.currentTime / self.maxTime) * 100.0

func _input(event):
   # This event resets the world switch timer, and we manually trigger the world
   # switch here.
   if event.is_action_pressed("force_world_timeout"):
    self._on_WorldSwitchTimer_timeout()

func _on_WorldSwitchTimer_timeout():
  # Sync the progress bar to the world switch timer
  self.currentTime = 0.0
  self.value = 0.0
  self.synced = true
