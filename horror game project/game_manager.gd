extends Node

@export var chalice_item: Item
@export var chalices_to_win:= 5
@onready var info_text = $Label
@onready var winscreen = get_node("Winscreen")
@onready var inventory: Inventory = $Player/Inventory
var game_over := false
func _ready():
	Engine.time_scale = 1
	GlobalSignals.on_give_player_item.connect(on_give_player_item)
	update_info_text()


func update_info_text():
	var current = inventory.get_number_of_item(chalice_item)
	info_text.text = "Find "+ str(current)+"/"+str(chalices_to_win)

func win_game():
	game_over = true
	winscreen.visible= true
	Engine.time_scale = 0

func _process(delta):
	if game_over and Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

func on_give_player_item(item, amount):
	update_info_text()
	print(inventory.get_number_of_item(chalice_item))
	if inventory.get_number_of_item(chalice_item) == chalices_to_win:
		win_game()
