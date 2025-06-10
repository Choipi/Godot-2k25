extends Node
class_name Player

@onready var network: NetworkManager = get_node("/root/Main/NetworkManager")

@export var username: String
@export var player_id: int

func _enter_tree():
	set_multiplayer_authority(self.name.to_int())

func _ready():
	username = network.local_username
	player_id = name.to_int()
	network.add_player_from_list(self)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		network.remove_player_from_list(self)
