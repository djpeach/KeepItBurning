extends Node2D

onready var fuelBar = $CanvasLayer/Control/FuelBar
onready var foodBar = $CanvasLayer/Control/FoodBar
onready var logsCounter = $CanvasLayer/Control/LogsCounter/Value
onready var foodTimer = $FoodConsumptionTimer
onready var sceneManager = $Utils

func _ready():
	var viewport_size = get_viewport_rect().size.x * get_viewport_transform().get_scale().x
	fuelBar.margin_left = (viewport_size / get_viewport_transform().get_scale().x) * fuelBar.get_transform().get_scale().x
	foodBar.value = Globals.foodValue
	fuelBar.value = Globals.fuelbarValue
	logsCounter.text = String(Globals.logsValue)
	EventBus.connect("update_logs_value", self, "_on_update_logs_value")

func _process(delta):
	if Globals.fuelbarValue <= 0:
		SceneManager.change_scene("res://ControlScenes/JoinScreen.tscn")

func _on_FuelBurnTimer_timeout():
	Globals.fuelbarValue -= 0.01
	fuelBar.value = Globals.fuelbarValue

func _on_FoodConsumptionTimer_timeout():
	Globals.foodValue -= 0.01
	foodBar.value = Globals.foodValue


