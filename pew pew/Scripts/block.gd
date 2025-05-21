extends Control

@export var colors: Array[Color]
var o_health:int
var health:int

func _ready():
	$Background.color = colors.pick_random()
	health = randi_range(get_parent().min_health,get_parent().max_health)
	o_health = health
	$health_label.text = str(health)
func _process(delta):
	position.y += get_parent().block_speed * delta
	$health_label.text = str(health)
	if position.y > 960:
		queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		health -= area.damage
		if health<= 0:
			area.get_parent().current_xp += o_health
			print(area.get_parent().current_xp)
			queue_free()
		area.queue_free()
