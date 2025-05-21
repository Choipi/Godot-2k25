extends Control

var o_health:int
var health:int

func _ready():
	
	health = get_parent().boss_health
	o_health = health
	$health_label.text = str(health)
func _process(delta):
	position.y += get_parent().boss_speed * delta
	$health_label.text = str(health)
	if position.y > 960:
		queue_free()
		get_parent().game_over()


func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		health -= area.damage
		if health<= 0:
			area.get_parent().current_xp += o_health
			queue_free()
			
		area.queue_free()
