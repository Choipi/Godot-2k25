extends Node


var ennemies: Array
var player: CharacterBody2D


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.connect("player_moved", Callable(self,"on_player_moved"))
	check_ennemies()
func check_ennemies():
	ennemies = get_tree().get_nodes_in_group("Ennemies")

func on_player_moved():

	for ennemy in ennemies:
		if ennemy:
			ennemy.move()


