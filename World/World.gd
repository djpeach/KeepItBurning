extends Node2D

onready var fuelBar = $CanvasLayer/Control/FuelBar
onready var foodBar = $CanvasLayer/Control/FoodBar
onready var foodTimer = $FoodConsumptionTimer

func _ready():
	var viewport_size = get_viewport_rect().size.x * get_viewport_transform().get_scale().x
	fuelBar.margin_left = (viewport_size / get_viewport_transform().get_scale().x) * fuelBar.get_transform().get_scale().x

func _on_FuelBurnTimer_timeout():
	fuelBar.value -= 0.01


func _on_FoodConsumptionTimer_timeout():
	Globals.foodValue -= .01
	foodBar.value = Globals.foodValue
