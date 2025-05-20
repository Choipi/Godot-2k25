extends Node
@export var obstacle:PackedScene
@export var coin:PackedScene


var GAME_HEIGHT = 960
var last_obstacle_position_y:String

var spawned_objects_x:int = 1700 
var objects_speed:int  = 700
var health_decrease:int = 5
var health_increase:int = 7
var health:float = 100.0
var score:float = 0
var score_increase_speed:int = 7


func _process(delta):
	#
	for obj in get_tree().get_nodes_in_group("dynamicObjects"):
		obj.position.x -= delta*objects_speed
		if obj.position.x < -200 and !obj.is_in_group("background"):  # Off-screen to the left
			obj.queue_free()
	if health > 0 :
		health -= delta*health_decrease
		$UI/Health.value = health
	else: 
		game_over()
	score+= delta*score_increase_speed
	$UI/Health/scorelabel.text =str(int(score))
	



func _on_spawner_t_imer_timeout():
	var random: int = randi()%2
	var obtacle_instance:Area2D = obstacle.instantiate()
	add_child(obtacle_instance)
	obtacle_instance.body_entered.connect(_on_obstacle_collided)
	obtacle_instance.position.x = spawned_objects_x

	if random:
		obtacle_instance.position.y= 100
		last_obstacle_position_y = "up"
		
	else:
		obtacle_instance.position.y= 860
		obtacle_instance.scale.y *= -1
		last_obstacle_position_y = "down"
	


func _on_spawn_coin_t_imer_timeout():
	var y_location: int = randi()%3
	var random_offset: int = randi_range(-100,100)
	if (y_location == 0 and last_obstacle_position_y != "up") or (y_location == 2 and last_obstacle_position_y != "down"):
		var tmp_y_position = get_position_by_index(y_location) + random_offset
		var coin_instance:Area2D = coin.instantiate()
		add_child(coin_instance)
		coin_instance.position.x = spawned_objects_x
		coin_instance.position.y = tmp_y_position
		coin_instance.body_entered.connect(_on_coin_collided.bind(coin_instance))

func get_position_by_index(index:int):
	match index:
		0:
			return 250
		1:
			return 470
		2:
			return 790

func _on_coin_collided(body:Node2D,coin_instance: Area2D):
	if body.is_in_group("Player"):
		health+= health_increase
		if health > 100: 
			health = 100
		coin_instance.get_node("AnimationPlayer").play("depop")
		$"Player/coin collected".play()
		await coin_instance.get_node("AnimationPlayer").animation_finished
		coin_instance.queue_free()


func _on_try_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func game_over():
	GlobalVariables.best_score = maxi(GlobalVariables.best_score,score)
	$Game_Over/best_score.text = "Best score: "+str(GlobalVariables.best_score)
	$Game_Over.show()
	$Game_Over/score.text = "your score: "+ str(int(score))
	$"Player/game over".play()
	get_tree().paused = true

func _on_obstacle_collided(body:Node2D):
	if body.is_in_group("Player"):
		game_over()
