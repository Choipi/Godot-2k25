extends Area2D

var damage := 1 

func _process(delta):
	position.y -= get_parent().bullet_speed * delta
	if position.y < 0 or position.x < 0 or position.x > 540:
		queue_free()
