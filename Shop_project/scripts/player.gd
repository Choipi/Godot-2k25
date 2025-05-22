extends Sprite2D

var min_position := Vector2(57,57)
var max_position := Vector2(1384,654)
# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = get_viewport().size.x/2
	position.y = get_viewport().size.y/2


func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event.position.y < get_viewport().size.y-157:
			position = event.position
			position.x = clamp(position.x,57,get_viewport().size.x-57)
			position.y =clamp(position.y,57,get_viewport().size.y-57)
