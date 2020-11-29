extends Control

func _ready():
	Lobby.close_connection()

func _on_HostButton_pressed():
	SceneManager.change_scene("res://ControlScenes/HostScreen.tscn")

func _on_JoinButton_pressed():
	SceneManager.change_scene("res://ControlScenes/JoinScreen.tscn")
