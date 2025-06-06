extends Sprite2D

var speed: float = 100.0
@export var min_x: float
@export var max_x: float
func _process(delta):
	position.x += delta * speed
	
	if position.x > max_x:
		position.x = min_x
