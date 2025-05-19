extends Control

var score:int = 0
var time_left: int = 5
var best_score: int = 0

func _on_inc_button_pressed():
	score += 1
	$scoreLabel.text = "Score: " + str(score)
	Input.vibrate_handheld(125)


func _on_timer_time_left_timeout():
	time_left -= 1
	$TimeLeft.text = "Time left: " +str(time_left)
	if time_left == 0:
		
		Global_V.best_score = max(Global_V.best_score,score)
		
		get_tree().change_scene_to_file("res://menu.tscn")
		
