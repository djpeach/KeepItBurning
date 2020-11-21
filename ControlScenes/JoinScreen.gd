extends Control

var joinedServer = false

onready var statusLabel = $Control/ServerDetails/StatusLabel
onready var joinControlBtn = $Control/JoinDetails/JoinControlButton
onready var usernameInput = $Control/JoinDetails/Username/UsernameInput
onready var usernameAlert = $UsernameAlert
onready var ipInput = $Control/JoinDetails/IP/IPInput
onready var ipAlert = $IPAlert
onready var loadingTimer = $Control/ServerDetails/LoadingTimer
onready var playerList = $Control/ServerDetails/VBoxContainer/PlayerList
onready var errorAlert = $ErrorAlert
onready var errorAlertLabel = $ErrorAlert/ErrorDescription

func _ready():
	Lobby.connect("refresh_players", self, "_refresh_players")
	Lobby.connect("server_disconnected", self, "_server_disconnected")
	Lobby.connect("connection_success", self, "_connection_success")
	Lobby.connect("connection_failure", self, "_connection_failure")
	
func _server_disconnected(reason):
	joinedServer = false
	statusLabel.text = "Status: " + reason
	joinControlBtn.text = "Join Server"
	playerList.clear()

func _connection_success():
	if loadingTimer:
		loadingTimer.queue_free()
	joinedServer = true
	statusLabel.text = "Status: Connected!"
	joinControlBtn.text = "Leave Server"
	
	_refresh_players()
	joinControlBtn.disabled = false
	
func _connection_failure(message):
	errorAlertLabel.text = message
	errorAlert.popup()
	joinControlBtn.disabled = false

func _on_JoinControlButton_pressed():
	if joinedServer:
		Lobby.close_connection()
	else:
		joinControlBtn.disabled = true
		var username = usernameInput.text.strip_edges(true, true)
		usernameInput.text = username
		var ip = ipInput.text.strip_edges(true, true)
		ipInput.text = ip
		if not ip:
			ipAlert.popup()
		elif not username:
			usernameAlert.popup()
		else:
			Lobby.create_client(username, ip);

func _on_Button_pressed():
	get_tree().change_scene("res://ControlScenes/BootScreen.tscn")
	
func _refresh_players():
	playerList.clear()
	if Lobby.peer:
		playerList.add_item(Lobby.player_name + " (You)")
		for player_name in Lobby.players.values():
			playerList.add_item(player_name)

var dots = 3
func _on_LoadingTimer_timeout():
	if dots >= 4:
		dots = 1
	var statusText = "Status: Pending "
	for _i in range(dots):
		statusText += ". "
	statusLabel.text = statusText
	dots += 1
