extends Area2D

onready var sprite = $Sprite
onready var collider = $CollisionShape2D

var quantity = 10

func _ready():
	var rand = randi() & 2
	sprite.flip_h = false if rand == 0 else true
	collider.rotate(PI / 4 if rand == 0 else -PI / 4)

func pickup(is_network_master):
	if is_network_master:
		Globals.healthValue = min(Globals.healthValue + 5, 100)
		if Globals.foodValue + quantity <= 100:
			Globals.foodValue += quantity
			rpc("remove")

remotesync func remove():
	queue_free()
