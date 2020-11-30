extends KinematicBody2D

const Food = preload("res://World/FoodItem.tscn")

export var max_health = 1
onready var health = max_health setget set_health
var invincible = false setget set_invincible

onready var blinkPlayer = $BlinkPlayer

func _on_HurtBox_area_entered(hitbox):
	if not invincible:
		invincible = true
		blinkPlayer.play("Blink")
		self.health -= hitbox.damage_value

func set_health(val):
	health = val
	if health <= 0:
		if randf() > 0.1:
			var food = Food.instance()
			get_tree().current_scene.add_child(food)
			food.global_position = global_position
		queue_free()

func set_invincible(val):
	invincible = val
