class_name  PlayerSlot
extends Panel

@onready var name_text = $Label
@onready var kick_button = $Button
var current_player:Player

func update_slot_ui(player:Player):
	current_player = player
	name_text.text = player.username
	
	var is_local = player.is_multiplayer_authority()
	if is_local:
		name_text.modulate = Color.FIREBRICK
	if multiplayer.is_server():
		kick_button.visible = true
	else:
		kick_button.visible = false

func _on_kick_button_pressed():
	if not multiplayer.is_server():
		return
	var network: NetworkManager = get_node("/root/Main/NetworkManager")
	network.disconnect_player.rpc(current_player.player_id)
