extends "res://Enemies/Enemy.gd"

var velocity = Vector2.LEFT

func _ready():
	$AnimationPlayer.play("attack")

func _process(delta):
	var flipped = velocity.x < 0
	$Sprite.flip_h = flipped
	$HitBox.position.x = -175 if flipped else 20
