extends Node

var Bullet = preload("res://src/entities/Bullet.tscn")

func _ready():
  pass

func _on_shoot(sourceType, pos, dir, speed, damage, scale):
  
  var sourceCollisionLayer = 0
  match(sourceType):
    "Player": 
      sourceCollisionLayer = 2
    "Mob":
      sourceCollisionLayer = 3
    _:
      sourceCollisionLayer = 0
      
  var collisionMask = inverse_mask_for_layer(sourceCollisionLayer)
  var newBullet = Bullet.instance()
  newBullet.createAndShoot(pos, dir, speed, damage, scale, collisionMask)
  self.add_child(newBullet)

func inverse_mask_for_layer(layer):
  if layer == 0:
    return 0
  return 255 - pow(2, layer - 1)
