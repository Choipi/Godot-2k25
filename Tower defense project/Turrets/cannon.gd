extends StaticBody3D


var bullet: PackedScene = preload("res://bullets/basic_bullet.tscn")
var bullet_damage := 5
var current_targets: Array = []
var curr: CharacterBody3D = null
var can_shoot := true
@export var fire_rate := 0.3
@export var cost: int

func _ready():
	$fire_rate.wait_time = fire_rate

func _process(delta):
	if is_instance_valid(curr):
		look_at(curr.global_position)
		if can_shoot:
			shoot()
			can_shoot = false
			$fire_rate.start()
	else:
		for child_index in get_node("Bullet_container").get_child_count():
			get_node("Bullet_container").get_child(child_index).queue_free()
			






func choose_target(current_targets:Array):
	var temp_array = current_targets
	var curr_target = null
	for target in temp_array:
		if curr_target == null:
			curr_target =target
		elif target.get_parent().get_progress() > curr_target.get_parent().get_progress():
			curr_target = target

	curr = curr_target


func _on_ennemy_detector_body_entered(body):
	if body.is_in_group("Ennemy"):
		print("ennemy entered")
		current_targets.append(body)
		choose_target(current_targets)


func _on_ennemy_detector_body_exited(body):
	if body.is_in_group("Ennemy"):
		print("ennemy exited")
		current_targets.erase(body)
		if body == curr:
			curr=null
		choose_target(current_targets)

func shoot():
	var temp_b = bullet.instantiate()
	temp_b.target = curr
	temp_b.bullet_damage = bullet_damage
	get_node("Bullet_container").add_child(temp_b)
	temp_b.global_position =$MeshInstance3D/Aim.global_position



func _on_fire_rate_timeout():
	can_shoot = true
