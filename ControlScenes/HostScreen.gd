extends Control

var serverRunning = false

onready var statusLabel = $Control/ServerDetails/StatusLabel
onready var serverControlBtn = $Control/HostDetails/ServerControlButton
onready var usernameInput = $Control/HostDetails/VBoxContainer/UsernameInput
onready var usernameAlert = $UsernameAlert
onready var loadingTimer = $Control/ServerDetails/LoadingTimer
onready var playerList = $Control/ServerDetails/VBoxContainer/PlayerList
onready var ipLabel = $Control/HostDetails/IPAddress
onready var startBtn = $Control/ServerDetails/StartGameButton
onready var errorAlert = $ErrorAlert
onready var errorAlertLabel = $ErrorAlert/ErrorDescription

func _ready():
	print("Your IP: {ip}".format({"ip": str(IP.get_local_addresses())}))
	Lobby.connect("refresh_players", self, "_refresh_players")
	Lobby.connect("server_disconnected", self, "_server_disconnected")
	Lobby.connect("connection_success", self, "_connection_success")
	Lobby.connect("connection_failure", self, "_connection_failure")
	
func _server_disconnected(reason):
	serverRunning = false
	statusLabel.text = "Status: " + reason
	serverControlBtn.text = "Start Server"
	startBtn.disabled = true
	playerList.clear()

func _connection_success():
	if loadingTimer:
		loadingTimer.queue_free()
	serverRunning = true
	statusLabel.text = "Status: Connected!"
	serverControlBtn.text = "End Server"
	
	_refresh_players()
	
	startBtn.disabled = false
	serverControlBtn.disabled = false
	
func _connection_failure(message):
	errorAlertLabel.text = message
	errorAlert.popup()
	serverControlBtn.disabled = false

func _on_ServerControlButton_pressed():
	if serverRunning:
		Lobby.close_connection()
	else:
		serverControlBtn.disabled = true
		var username = usernameInput.text.strip_edges(true, true)
		usernameInput.text = username
		if not username:
			usernameAlert.popup()
		else:
			Lobby.create_server(username)


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


func _on_StartGameButton_pressed():
	Lobby.init_game()
