extends Node

var players: Array[Player]
var local_player: Player

var max_x = 400
var max_y = 230
var score_to_win = 1

@onready var end_screen = $"../EndScreen"
@onready var end_screen_winner = $"../EndScreen/Label"
@onready var end_screen_button = $"../EndScreen/Button"

func get_random_spawn_pos():
	return Vector2(randf_range(-max_x,max_x), randf_range(-max_y,max_y))

func on_player_die(player_id:int, attacker_id: int):
	var player: Player = get_player(player_id)
	var attacker: Player = get_player(attacker_id)
	
	attacker.increase_score(1)
	
	if attacker.score >= score_to_win:
		end_game_client.rpc(attacker.player_name)

func get_player(player_id:int) -> Player:
	for player in players:
		if player.player_id == player_id:
			return player
	return null

func game_reset():
	hide_end_screen.rpc()
	for player in players:
		player.respawn()
		player.score = 0
		

@rpc("authority", "call_local", "reliable")
func hide_end_screen():
	end_screen.visible = false

@rpc("authority", "call_local", "reliable")
func end_game_client(winner_name:String):
	end_screen.visible = true
	end_screen_winner.text = str(winner_name, " has won!")
	end_screen_button.visible = multiplayer.is_server()

func _on_button_pressed():
	game_reset()
