extends Control

var buttons: Array[Node]

var red_skin:= load("res://Assets Godot In-Game Shop/Players/Red.png")
var purple_skin:=  load("res://Assets Godot In-Game Shop/Players/Violet.png")
var yellow_skin:= load("res://Assets Godot In-Game Shop/Players/Yellow.png")
var pink_skin:= load("res://Assets Godot In-Game Shop/Players/Pink.png")

func _ready():
	Global.load_data()
	$"../Shop_window/coins_label".text = Global.get_coins_as_text()+ "$"
	connect_signals()
func connect_signals():
	buttons = get_tree().get_nodes_in_group("buy")
	for child in buttons:
		child.connect("pressed", on_button_pressed.bind(child,buttons.find(child)))

func on_button_pressed(button, button_index):
	var price = int(button.text.split("$")[0])
	button.text = "selected"
	Global.data["coins"] -= price
	for i in buttons.size():
		Global.data["items"][str(i)] = false
	Global.data["items"][str(button_index)] = true
	equip_new_skin(button_index)

func equip_new_skin(index):
	match index:
		0:
			$"../player".texture = red_skin
			
		1:
			$"../player".texture = pink_skin
			
		2:
			$"../player".texture = purple_skin
			
		3:
			$"../player".texture = yellow_skin
	

func _on_button_pressed():
	$"../Shop_window".visible = !$"../Shop_window".visible  


func _on_shop_window_close_requested():
	$"../Shop_window".hide()


func _on_increase_coin_pressed():
	Global.data["coins"] += 100
	$"../Shop_window/coins_label".text = Global.get_coins_as_text()+ "$"
	Global.save_data()

