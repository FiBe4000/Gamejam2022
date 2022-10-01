tool
extends KinematicBody2D


export var speed = 500


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta):
    var dir = Vector2()
    if not Engine.editor_hint:
        dir.x -= Input.get_action_strength("move_left")
        dir.x += Input.get_action_strength("move_right")
        dir.y -= Input.get_action_strength("move_up")
        dir.y += Input.get_action_strength("move_down")
    
    var offset = speed * dir
    
    self.translate(delta * offset)


func _draw():
    var shape = self.get_node("CollisionShape2D")
    var pos = shape.transform.origin
    var dim = shape.shape.extents
    var col = Color(1, 0, 0, 1)
    draw_rect(Rect2(pos, dim), col)
