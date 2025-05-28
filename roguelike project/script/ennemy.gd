extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("Player")

var health:= 3
var damage:= 1

var attack_chance:= 0.5



func move():
	if randf()< 0.5:
		return
	var direction:= Vector2.ZERO
	var can_move:= false
	
	while(!can_move):
		direction = get_random_direction()
		var space_rid = get_world_2d().space
		var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(48,48) * direction )
		var result = space_state.intersect_ray(query)
		
		if result:
			if result.collider.is_in_group("Wall"):
				return
		
		if !result and global_position + 48 * direction != player.position:
			can_move = true
		
		position += 48 * direction
		
func get_random_direction():
		var ran = randi_range(0,3)
		
		match ran:
			0:
				return Vector2.UP
				
			1:
				return Vector2.DOWN
				
			2:
				return Vector2.LEFT
				
			3:
				return Vector2.RIGHT
		return Vector2.ZERO


func take_damage(damage_taken):
	health -= damage_taken
	
	if health <= 0:
		queue_free()
	
	if randf() > attack_chance:
		player.take_damage(damage)


