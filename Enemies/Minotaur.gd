extends "res://Enemies/Enemy.gd"

var velocity = Vector2.LEFT
export var speed = 2000
var player = null

func _ready():
	$AnimationPlayer.play("attack")

func _process(delta):
	velocity = (player.global_position - global_position).normalized() * speed * delta
	var flipped = sign(velocity.x) < 0
	$Sprite.flip_h = flipped
	$HitBox.position.x = -175 if flipped else 20
	velocity = move_and_slide(velocity)
