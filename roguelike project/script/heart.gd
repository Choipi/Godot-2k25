extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		queue_free() # Replace with function body.
