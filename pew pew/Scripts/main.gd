extends Node
@export var block: PackedScene 
@export var bullet: PackedScene 
@export var boss: PackedScene 
var bullet_speed := 300
var block_speed := 150
var block_width := 108
var min_health := 5
var max_health := 15
var player_max_health := 3.0
var player_cur_health := 3.0
var cur_level := 1
var max_xp_to_level_up:= 100.0
var current_xp:=0.0
var damage_from_blocks := 1
var damage_increase:= 1

var boss_health := 500
var boss_speed := 50

var distance_before_boss := 60.0
var cur_distance := 0.0
var distance_speed:= 1.0



func _ready():
	$UI/Level.text = str(cur_level)
func _process(delta):
	
	cur_distance+= delta*distance_speed
	$UI/distance_before_boss_bar.value = cur_distance/distance_before_boss*100
	if int(cur_distance) == int(distance_before_boss):
		boss_time()
	
	
	$UI/xp_bar.value = current_xp/max_xp_to_level_up * 100
	if current_xp >= max_xp_to_level_up:
		level_up()

func level_up():
	cur_level += 1
	current_xp -= max_xp_to_level_up
	max_xp_to_level_up *= 2 
	$UI/Level.text = str(cur_level)
	player_gains_health(1)
	$UI/Label/POP_UP_ANIM.play("POP_UP_ANIM")
	damage_increase*=2
	$Fire_rate.wait_time = $Fire_rate.wait_time * 90/100 
	
func _on_fire_rate_timeout():
	if player_cur_health > 0:
		var bullet_instance: Area2D = bullet.instantiate()
		add_child(bullet_instance)
		bullet_instance.position = $Player.position
		bullet_instance.damage*= damage_increase
	else:
		$Fire_rate.stop()

func _on_block_timer_timeout():
	var block_instance = block.instantiate()
	add_child(block_instance)
	var random_index = randi_range(0,4)
	block_instance.position.x = block_width* random_index
	block_instance.position.y = -block_width


func _on_player_area_entered(area):
	if area.is_in_group("block"):
		area.get_parent().queue_free()
		player_looses_health(damage_from_blocks)

func player_looses_health(amount:int):
	if $Invicibility_timer.is_stopped():
			player_cur_health-=amount

			$Invicibility_timer.start()
			$Player/AnimationPlayer.play("invincibility")
			
			$UI/health_bar.value = player_cur_health/player_max_health*$UI/health_bar.max_value  
			
			if player_cur_health <= 0:
				$Player.queue_free()
				game_over()

func player_gains_health(amount:int):
	player_cur_health+= amount
	player_cur_health = clamp(player_cur_health,0,max_health)
	$UI/health_bar.value = player_cur_health/player_max_health*$UI/health_bar.max_value  

func boss_time():
	$Block_Timer.autostart = false
	$Block_Timer.stop()
	$time_before_Boss_Spawn.start()

func _on_time_before_boss_spawn_timeout():
	var boss_instance = boss.instantiate()
	add_child(boss_instance)
	boss_instance.position.x = block_width* 2
	boss_instance.position.y = -400
	
	


func _on_play_again_pressed():
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
	
func game_over():
	$Game_Over.show()
	get_tree().paused = true
