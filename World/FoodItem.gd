extends Area2D

onready var sprite = $Sprite
onready var collider = $CollisionShape2D

func _ready():
	var rand = randi() & 2
	sprite.flip_h = false if rand == 0 else true
	collider.rotate(PI / 4 if rand == 0 else -PI / 4)
	
func get_type():
	return "FoodItem"

func _on_FoodItem_body_entered(body):
	assert(body.has_method("increment_food"))
	body.increment_food()
	queue_free()
