extends Node2D

onready var fuelBar = $CanvasLayer/Control/FuelBar
onready var foodBar = $CanvasLayer/Control/FoodBar
onready var healthBar = $CanvasLayer/Control/HealthBar
onready var logsCounter = $CanvasLayer/Control/LogsCounter/Value
onready var foodTimer = $FoodConsumptionTimer
onready var currentScore = 0
onready var scoreLabel = $CanvasLayer/Control/Score

var Wood = preload("res://World/Logs.tscn")
var Minotaur = preload("res://Enemies/Minotaur.tscn")

func _ready():
	Globals.reset()
	var viewport_size = get_viewport_rect().size.x * get_viewport_transform().get_scale().x
	fuelBar.margin_left = (viewport_size / get_viewport_transform().get_scale().x) * fuelBar.get_transform().get_scale().x
	foodBar.value = Globals.foodValue
	fuelBar.value = Globals.fuelbarValue
	logsCounter.text = String(Globals.logsValue)
	EventBus.connect("update_logs_value", self, "_on_update_logs_value")

func _process(delta):
	logsCounter.text = String(Globals.logsValue)
	healthBar.value = Globals.healthValue
	if Globals.healthValue <= 0:
		SceneManager.change_scene("res://ControlScenes/EndScreen.tscn")

func _on_FuelBurnTimer_timeout():
	Globals.fuelbarValue -= 0.01
	fuelBar.value = Globals.fuelbarValue
	if Globals.fuelbarValue <= 0:
		SceneManager.change_scene("res://ControlScenes/EndScreen.tscn")

func _on_FoodConsumptionTimer_timeout():
	Globals.foodValue = max(Globals.foodValue - 0.01, 0)
	foodBar.value = Globals.foodValue
	if Globals.foodValue <= 0:
		Globals.healthValue = max(Globals.healthValue - 0.05, 0)

func _on_ScoreTimer_timeout():
	Globals.score += 1
	scoreLabel.text = "Days survived: " + String(Globals.score)

func _on_EnemySpawnTimer_timeout():
	rpc("add_minotaur")

remotesync func add_minotaur():
	var enemyPosition = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	
	var players = get_node("YSort/Players").get_children()
	var player = players[rand_range(0, players.size())]
	var minotaur = Minotaur.instance()
	minotaur.player = player
	var pos = player.position
	
	var dir = ["up", "down", "left", "right"][rand_range(0, 4)]
	
	match dir:
		"up":
			pos += Vector2(rand_range(-175, 175), -105)
		"down":
			pos += Vector2(rand_range(-175, 175), 105)
		"left":
			pos += Vector2(-175, rand_range(-105, 105))
		"right":
			pos += Vector2(175, rand_range(-105, 105))

	minotaur.position = pos
	add_child(minotaur)
	
func _on_WoodSpawnTimer_timeout():
	var wood = Wood.instance()
	get_tree().current_scene.add_child(wood)
	wood.global_position = Vector2(rand_range($TopLeftBound.position.x, $BottomRightBound.position.x), rand_range($BottomRightBound.position.y, $TopLeftBound.position.y))
