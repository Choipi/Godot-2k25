extends Node

var player_health:= 100
var money := 200

var wave := 0

var ennemies_alive := 0

func reset() -> void:
	player_health= 100
	money = 200
	wave = 1
	ennemies_alive = 0
