extends Node

var map_width:= 7
var map_height:= 7
var rooms_to_generate := 12
var room_count := 0
var first_room_position: Vector2

@onready var room_scene: PackedScene = load("res://Scenes/base.tscn")

@export var ennemy_spawn_chance: float
@export var coin_spawn_chance: float
@export var heart_spawn_chance: float

@export var max_ennemy_per_room: float
@export var max_coins_per_room: float
@export var max_hearts_per_room: float

var map: Array

var room_instanciated:= false
var room_nodes:Array

func _ready():
	for i in range(map_width):
		map.append([])
		for j in range(map_height):
			map[i].append(false)
	seed(Global.seed)
	generate()
	
	$"../CharacterBody2D".global_position = (first_room_position * 816) + Vector2(262,262)

func generate():
	check_room(3,3,0,Vector2.ZERO,true)
	instantiate_room()
	var preview = ""
	for i in range(map_width):
		for j in range(map_height):
			preview += "|o|" if map[j][i] else "|x|" 
		preview += "\n"
	print(preview)
func check_room(x, y, remaining, general_direction,first_room=false):
	if room_count >= rooms_to_generate:
		return
	if x<0 or x > map_width-1 or y<0 or y > map_height-1:
		return
	if !first_room and remaining <= 0:
		return
	if first_room:
		first_room_position = Vector2(x,y)
	room_count+= 1
	map[x][y] = true
	
	var north = randf() > (0.2 if general_direction == Vector2.UP else 0.8 )
	var east = randf() > (0.2 if general_direction == Vector2.RIGHT else 0.8 )
	var south = randf() > (0.2 if general_direction == Vector2.DOWN else 0.8 )
	var west = randf() > (0.2 if general_direction == Vector2.LEFT else 0.8 )
	
	var max_remaining = rooms_to_generate
	
	if north or first_room:
		check_room(x,y-1,max_remaining if first_room else remaining -1,Vector2.UP if first_room else general_direction)
	if east or first_room:
		check_room(x-1,y,max_remaining if first_room else remaining -1,Vector2.RIGHT if first_room else general_direction)
	if south or first_room:
		check_room(x,y+1,max_remaining if first_room else remaining -1,Vector2.DOWN if first_room else general_direction)
	if west or first_room:
		check_room(x+1,y,max_remaining if first_room else remaining -1,Vector2.LEFT if first_room else general_direction)

func instantiate_room():
	if room_instanciated:
		return
	room_instanciated = true
	
	for x in range(map_width):
		for y in range(map_height):
			if !map[x][y] :
				continue
			var room = room_scene.instantiate()
			room.position = Vector2(x,y) * 816
			if y < map_height - 1 and map[x][y+1] == true:
				room.south()
			if y > 0 and map[x][y-1] == true:
				room.north()
			if x < map_width -1 and map[x+1][y] == true:
				room.east()
			if x > 0 and map[x-1][y] == true:
				room.west()
			
			if first_room_position != Vector2(x,y):
				room.Generation = self
			$"..".call_deferred("add_child", room)
			room_nodes.append(room)
