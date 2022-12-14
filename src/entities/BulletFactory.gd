extends Node

var Bullet = preload("res://src/entities/Bullet.tscn")

func _ready():
  pass

func _on_shoot(sourceType, pos, dir, speed, damage, scale):
  
  var sourceCollisionLayer = 0
  match(sourceType):
    "Player": 
      sourceCollisionLayer = 2
    "Mob", "morn", "akites_rass_professor":
      sourceCollisionLayer = 3
    _:
      sourceCollisionLayer = 0
      
  var collisionMask : int = inverse_mask_for_layer(sourceCollisionLayer)
  # Layer 5 is water which we do not want to hit with bullets
  collisionMask = collisionMask & ~(1 << 4)
  var newBullet = Bullet.instance()
  newBullet.createAndShoot(sourceType, pos, dir, speed, damage, scale, collisionMask)
  self.add_child(newBullet)
  newBullet.z_index = 4

func inverse_mask_for_layer(layer):
  if layer == 0:
    return 0
  return 255 - pow(2, layer - 1)
