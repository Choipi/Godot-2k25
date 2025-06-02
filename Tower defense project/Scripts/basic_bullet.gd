extends CharacterBody3D


var target: CharacterBody3D
var speed:= 200
var bullet_damage

func _physics_process(delta):
	if is_instance_valid(target):
		velocity = global_position.direction_to(target.global_position) * speed* delta
		
		move_and_slide()
	else:
		queue_free()


func _on_hitbox_body_entered(body):
	if body.is_in_group("Ennemy"):
		body.take_damage(bullet_damage)
		queue_free()
