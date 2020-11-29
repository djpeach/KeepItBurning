extends Node2D

onready var fuelBar = $CanvasLayer/Control/FuelBar
onready var foodBar = $CanvasLayer/Control/FoodBar
onready var healthBar = $CanvasLayer/Control/HealthBar
onready var logsCounter = $CanvasLayer/Control/LogsCounter/Value
onready var foodTimer = $FoodConsumptionTimer
onready var currentScore = 0
onready var scoreLabel = $CanvasLayer/Control/Score

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
	if Globals.fuelbarValue <= 0:
		SceneManager.change_scene("res://ControlScenes/EndScreen.tscn")

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

func _on_ScoreTimer_timeout():
	Globals.score += 1
	scoreLabel.text = "Days survived: " + String(Globals.score)
