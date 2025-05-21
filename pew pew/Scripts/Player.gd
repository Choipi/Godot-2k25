extends Area2D

var LIMIT_LEFT := 40
var LIMIT_RIGHT :=500

func _input(event):
	if Input.is_action_pressed("click"):
		position.x = event.position.x
		position.x = clamp(position.x,LIMIT_LEFT,LIMIT_RIGHT)
