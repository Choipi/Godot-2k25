extends InteractableObject

@export var item_name : String

func _interact ():
	var item = load("res://Horror Game - Assets/Items/Item Data/" + item_name + ".tres")
	GlobalSignals.on_give_player_item.emit(item, 1)
	queue_free()
