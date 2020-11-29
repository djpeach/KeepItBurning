extends Control

func _ready():
	$Label.text = "Survived for: "+String(Globals.score)+" days"

func _on_Button_button_down():
	$Label.text = "Survived for: "+String(Globals.score)+" days"
	SceneManager.change_scene("res://ControlScenes/BootScreen.tscn")
