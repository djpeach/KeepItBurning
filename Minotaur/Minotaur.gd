extends KinematicBody2D


# Declare member variables
onready var animState = $AnimationTree.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
