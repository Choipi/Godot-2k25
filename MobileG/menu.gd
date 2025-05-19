extends Control

var best_score = 0
@export var best_score_label: Label

func _ready():
	best_score_label.text = "best score: " + str(Global_V.best_score)

func _on_startbutton_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
