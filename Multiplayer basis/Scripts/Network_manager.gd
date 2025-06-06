extends Node

const MAX_CLIENTS: int = 4
@onready var network_ui = $NetworkUi
@onready var ip_input = $"NetworkUi/VBoxContainer/IP input"
@onready var port_input = $"NetworkUi/VBoxContainer/PORT input2"

var player_scene = preload("res://Scenes/Player.tscn")
@onready var spawned_nodes = $SpawnedNodes
var local_username: String

var spawn_min_x = -350
var spawn_max_x = 350

var spawn_min_y = -200
var spawn_max_y = 200

func _ready():
	pass

func start_host():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(port_input.text),MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	_on_player_connected(multiplayer.get_unique_id())
	
	network_ui.visible = false


func start_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_input.text, int(port_input.text))
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connexion_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)

func _on_player_connected(id: int):
	print("Player %d joined"% id)
	
	var player = player_scene.instantiate()
	player.name = str(id)
	player.player_id = id
	spawned_nodes.add_child(player, true)

func _on_player_disconnected(id: int):
	print("Player %d left" % id)
	
	if not spawned_nodes.has_node(str(id)):
		return
	spawned_nodes.get_node(str(id)).queue_free()

func _connected_to_server():
	print("Connected to server")
	network_ui.visible = false
	
func _connexion_failed():
	print("Connection failed")
func _server_disconnected():
	network_ui.visible = true

func get_random_spawn_pos():
	return Vector2(randf_range(spawn_min_x,spawn_max_x), randf_range(spawn_min_y,spawn_max_y))

func _on_username_input_3_text_changed(new_text):
	local_username = new_text
