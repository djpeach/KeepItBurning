extends KinematicBody2D

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
	print('set health to ' + str(val))
	health = val
	if health <= 0:
		queue_free()

func set_invincible(val):
	invincible = val
