extends Node

signal refresh_players()
signal server_disconnected(reason)
signal connection_success()
signal connection_failure(message)

const PORT = 10987
const MAX_PEERS = 4

var peer = null
var players = {}
var ready_players = []

var player_name = ''

func _ready():
	get_tree().connect("network_peer_connected", self, "_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")

# Lobby local-client-only methods
func create_server(player_name):
	self.player_name = player_name
	peer = NetworkedMultiplayerENet.new()
	var res = peer.create_server(PORT, MAX_PEERS)
	if res == OK:
		get_tree().network_peer = peer
		emit_signal("connection_success")
	else:
		emit_signal("connection_failure")

func create_client(player_name, ip):
	self.player_name = player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(str(ip), PORT)
	get_tree().network_peer = peer
	
func close_connection():
	peer = null
	get_tree().network_peer = null
	players.clear()
	if is_network_master():
		emit_signal("server_disconnected", "Server Closed")
	else:
		emit_signal("server_disconnected", "Left Server")

func init_game():
	assert(get_tree().is_network_server())
	
	var spawn_points = {}
	spawn_points[get_tree().get_network_unique_id()] = 0
	
	var spawn_index = 1
	for player_id in players.keys():
		spawn_points[player_id] = spawn_index
		spawn_index += 1
	
	for player_id in players.keys():
		rpc_id(player_id, "prepare_for_game", spawn_points, false)
	
	prepare_for_game(spawn_points, true)
		
# SceenTree signal callbacks
func _client_connected(id):
	print(id)
	# tell the connecting client to add us to their player list
	rpc_id(id, "add_player", self.player_name)

func _client_disconnected(id):
	players.erase(id)
	emit_signal("refresh_players")

func _server_disconnected():
	peer = null
	get_tree().network_peer = null
	emit_signal("server_disconnected", "Closed by Host")
	players.clear()

func _connected_to_server():
	emit_signal("connection_success")
	
func _connection_failed():
	print("_connection_failed")
	emit_signal("connection_failure", "Failed to connect to host")
	
# RPC-available calls to and from other clients
remote func add_player(player_name):
	var id = get_tree().get_rpc_sender_id()
	players[id] = player_name
	emit_signal("refresh_players")

remote func prepare_for_game(spawn_points, is_host):
	var world = load("res://World/World.tscn").instance()
	get_tree().get_root().add_child(world)
	
	if get_tree().is_network_server():
		get_tree().get_root().get_node("HostScreen").hide()
	else:
		get_tree().get_root().get_node("JoinScreen").hide()
	
	# local player
	var player_scene = load("res://Player/Player.tscn")
	
	for player_id in spawn_points.keys():
		var spawn_point = world.get_node("SpawnPoints/{index}".format({"index": spawn_points[player_id]})).position
		var player = player_scene.instance()
		
		player.set_name(str(player_id))
		player.position = spawn_point
		player.set_network_master(player_id)
		
		world.get_node("YSort/Players").add_child(player)
	
	if not get_tree().is_network_server():
		rpc_id(1, "ready_up")
	else:
		start_game()
	
remote func ready_up():
	assert(get_tree().is_network_server())
	
	var senderId = get_tree().get_rpc_sender_id()
	
	if not senderId in ready_players:
		ready_players.append(senderId)
	
	if ready_players.size() == players.size():
		for player_id in players.keys():
			rpc_id(player_id, "start_game")
		start_game()

remote func start_game():
	ready_players.clear()
	get_tree().set_pause(false)
	
	
	
	
	
	
	
	
	
	
