extends KinematicBody2D

export var speed = 90

puppet var puppet_velocity = Vector2.ZERO
puppet var puppet_position = Vector2()
var flipped = false
onready var animState = $AnimationTree.get("parameters/playback")

func _ready():
	$AnimationTree.active = true
	if is_network_master():
		$Camera2D.make_current()
	
remote func _set_position(pos):
	global_transform.origin = pos

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	var input_vector = Vector2.ZERO
	if is_network_master():
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		
		velocity = input_vector * speed
		
		rset("puppet_velocity", velocity)
		rset("puppet_position", position)
	else:
		position = puppet_position
		velocity = puppet_velocity
		
	if velocity != Vector2.ZERO:
		if velocity.x != 0:
			flipped = velocity.x < 0
		
		animState.travel("walk")
	else:
		animState.travel("idle")
		
	if is_network_master():
		if Input.is_action_pressed("attack"):
			rpc("setAnimation", "attack")
		
	$Sprite.flip_h = flipped
	$Sprite.position.x = -2.5 if flipped else 5.0
	$KinematicCollider.position.x = 2.5 if flipped else 0.0
	
	# to avoid jittering
	puppet_velocity = move_and_slide(velocity)
	if not is_network_master():
		puppet_position = position
		

remotesync func setAnimation(animation):
	animState.travel(animation)


func _on_OverlapDetection_area_entered(area):
	var is_network_master = is_network_master()
	if area.get_groups().has("resource"):
		assert(area.has_method("pickup"))
		area.pickup(is_network_master)
	elif area.get_groups().has("interactable"):
		assert(area.has_method("interact"))
		area.interact(is_network_master)
