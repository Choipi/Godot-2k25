extends Node2D


var speed:int  = 800

func _process(delta):
	position.x -= delta*speed
	
	if position.x <= -$Background.texture.get_width() * $Background.get_scale().x:
		position.x = 0
