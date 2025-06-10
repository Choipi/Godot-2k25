extends Control
@onready var ScneManager:SceneManager = get_node("/root/Main")
@onready var network: NetworkManager = get_node("/root/Main/NetworkManager")
var player_slots: Array[PlayerSlot] = []
@onready var player_slot_parent = $PLayerSlotList
@onready var start_button = $StartButton


func _ready():
	for slots in player_slot_parent.get_children():
		player_slots.append(slots)
func update_ui():
	if not visible:
		return
	
	start_button.visible = multiplayer.is_server()
	var player_count = len(network.current_players)
	for i in len(player_slots):
		var slot = player_slots[i]
		if i < player_count:
			slot.visible = true
			slot.update_slot_ui(network.current_players[i])
		else:
			slot.visible = false

func _on_start_button_pressed():
	ScneManager.load_game_scene.rpc()


func _on_quit_button_pressed():
	multiplayer.multiplayer_peer.close()
