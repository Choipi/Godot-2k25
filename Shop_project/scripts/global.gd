extends Node

var path:= "user://save.txt"


var data: Dictionary = {
	"items":{
		"1":false,
		"2":true,
		"0":false,
		"3":false,
	},
	"selected_player_index" : 1,
	"coins": 0,
}

func save_data():
	var file = FileAccess.open(path,FileAccess.WRITE)
	var game_data:= {
		"data"= data,
	}
	file.store_var(game_data)
	file.close()

func load_data():
	var file = FileAccess.open(path,FileAccess.READ)
	if !FileAccess.file_exists(path):
		return
	var game_data = file.get_var()
	data = game_data["data"]

func get_coins_as_text():
	return str(data["coins"])

