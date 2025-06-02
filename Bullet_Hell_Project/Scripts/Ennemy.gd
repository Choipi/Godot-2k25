extends CharacterBody2D
class_name Ennemy


@export var speed:float
@export var damage: float
@export var health: float
@export var attack_range: float

@onready var player = get_tree().get_nodes_in_group("Player")[0]
var player_distance: float

var can_attack: bool
var can_move: bool
var is_alive:bool
var is_attacking := false
@export var hitbox: CollisionShape2D

func attack():
	pass

func take_damage(damage_taken):
	health -= damage_taken
	if health <= 0 : 
		queue_free()
