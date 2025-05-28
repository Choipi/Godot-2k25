extends Node2D

var inside_width := 9
var inside_height := 9

@onready var Generation: Node

@export var ennemy_node: PackedScene
@export var heart_node: PackedScene
@export var coin_node: PackedScene
@export var key_node: PackedScene
@export var exit_node: PackedScene

var used_postion: Array

func _ready():
	if Generation:
		generate_indoor()
func north():
	$north_door.visible = true
	$north_wall.queue_free()

func south():
	$south_door.visible = true
	$south_wall.queue_free()

func east():
	$east_door.visible = true
	$east_wall.queue_free()

func west():
	$west_door.visible = true
	$west_wall.queue_free()


func generate_indoor():
	if randf_range(0,1) < Generation.ennemy_spawn_chance:
		spawn_node(ennemy_node,1, Generation.max_ennemy_per_room)
	if randf_range(0,1) < Generation.heart_spawn_chance:
		spawn_node(heart_node,0, Generation.max_hearts_per_room)
	if randf_range(0,1) < Generation.coin_spawn_chance:
		spawn_node(coin_node,0 ,Generation.max_coins_per_room)
	

func spawn_node(node,min_ins=0,max_ins=0):
	var num= 1
	if min_ins != 0 or max_ins!= 0:
		num = randi_range(min_ins,max_ins)
		
	for i in range(num):
			var node_obj = node.instantiate()
			var pos = Vector2(48* randi_range(2,inside_width -1 )-24,48* randi_range(2,inside_width -1 )-24)
			while pos in used_postion:
				pos = Vector2(48* randi_range(2,inside_width -1 )-24,48* randi_range(2,inside_width -1 )-24)
			node_obj.position = pos
			used_postion.append(pos)
			add_child(node_obj)
	if node == ennemy_node:
		get_tree().get_first_node_in_group("Ennemy_Manager").check_ennemies()
