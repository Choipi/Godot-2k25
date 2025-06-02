extends Ennemy
class_name AIController


func _ready():
	can_attack= true
	can_move = true
	is_alive = true
func _process(delta):
	if player:
		player_distance = position.distance_to(player.position)


func _physics_process(delta):
	if can_move and is_alive:
		var direction = (player.global_position - self.global_position).normalized()
		velocity = speed * direction
		move_and_slide()
		if direction.x > 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false

func take_damage(damage_taken):
	super.take_damage(damage_taken)
