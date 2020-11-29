extends Node2D

onready var fuelBar = $CanvasLayer/Control/FuelBar
onready var foodBar = $CanvasLayer/Control/FoodBar
onready var healthBar = $CanvasLayer/Control/HealthBar
onready var logsCounter = $CanvasLayer/Control/LogsCounter/Value
onready var foodTimer = $FoodConsumptionTimer

var enemy1 = preload("res://Enemies/Minotaur.tscn")

func _ready():
	var viewport_size = get_viewport_rect().size.x * get_viewport_transform().get_scale().x
	fuelBar.margin_left = (viewport_size / get_viewport_transform().get_scale().x) * fuelBar.get_transform().get_scale().x
	foodBar.value = Globals.foodValue
	fuelBar.value = Globals.fuelbarValue
	logsCounter.text = String(Globals.logsValue)
	EventBus.connect("update_logs_value", self, "_on_update_logs_value")

func _process(delta):
	if Globals.fuelbarValue <= 0:
		# also do scoring
		# game over (SceneManager.change_scene(<game over scene>))
		pass

func  _on_update_logs_value(val):
	logsCounter.text = String(val)

func _on_FuelBurnTimer_timeout():
	Globals.fuelbarValue -= 0.01
	fuelBar.value = Globals.fuelbarValue

func _on_FoodConsumptionTimer_timeout():
	Globals.foodValue = max(Globals.foodValue - 0.01, 0)
	foodBar.value = Globals.foodValue
	if Globals.foodValue <= 0:
		Globals.healthValue = max(Globals.healthValue - 0.05, 0)
		healthBar.value = Globals.healthValue
		if Globals.healthValue <= 0:
			# SceneManager.change_scene("game_over")
			pass


func _on_EnemySpawnTimer_timeout():
	#makes invisible box where enemies are able to spawn
	var enemyPosition = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	
	var player = get_node("YSort/Players")
	var e = enemy1.instance()
	var pos = player.position
	if randf() < 0.5:
	# On the left
		pos.x -= rand_range(50.0, 200.0)
	else:
	# On the right
		pos.x += rand_range(50.0, 200.0)

	e.position = pos
	add_child(e)
	
	
	
