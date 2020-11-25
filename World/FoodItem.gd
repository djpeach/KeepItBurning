extends Area2D

onready var sprite = $Sprite
onready var collider = $CollisionShape2D

func _ready():
	var rand = randi() & 2
	sprite.flip_h = false if rand == 0 else true
	collider.rotate(PI / 4 if rand == 0 else -PI / 4)


func pickup():
	if Globals.foodValue <= 90:
		Globals.foodValue += 10
		queue_free()
