extends Node2D


func _ready():
  if get_parent().has_method("get_health_percent"):
    $PanelContainer/ProgressBar.value = get_parent().get_health_percent() * 100


func _on_Parent_health_changed(health_percent):
  $PanelContainer/ProgressBar.value = health_percent * 100
