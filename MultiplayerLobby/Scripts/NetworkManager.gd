class_name  NetworkManager
extends Node

signal OnConnecteToServer
signal OnServerDisconnected

var plyer_scene = preload("res://Scene/Player.tscn")
@onready var spawned_nodes = $MultiplayerSpawner

var local_username: String
var current_players: Array = []

func start_host(port:int):
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port,8)
	multiplayer.multiplayer_peer = peer
	
	current_players = []
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	_on_player_connected(multiplayer.get_unique_id())
	_connected_to_server()
	
func start_client(ip:String, port:int):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip,port)
	multiplayer.multiplayer_peer = peer
	
	current_players = []
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(_disconnected_server)

@rpc("any_peer", "call_local", "reliable")
func disconnect_player(player_id:int):
	multiplayer.multiplayer_peer.disconnect_peer(player_id)

func _on_player_connected(id :int):
	var player = plyer_scene.instantiate()
	player.name = str(id)
	spawned_nodes.add_child(player, true)

func _on_player_disconnected(id :int):
	var node = spawned_nodes.get_node(str(id))
	if current_players.has(node):
		remove_player_from_list(node)
	
	if node:
		node.queue_free()

func _connected_to_server():
	OnConnecteToServer.emit()

func _disconnected_server():
	OnServerDisconnected.emit()

func connection_failed():
	pass


func add_player_from_list(player):
	current_players.append(player)

func remove_player_from_list(player):
	current_players.erase(player)
