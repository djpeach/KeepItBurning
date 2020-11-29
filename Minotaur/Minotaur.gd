extends KinematicBody2D


# Declare member variables
var knockback = Vector2.ZERO
onready var animState = $AnimationTree.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	animState.travel("idle")
	$AnimationTree.active = true

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * _delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	knockback = Vector2.RIGHT * 400
