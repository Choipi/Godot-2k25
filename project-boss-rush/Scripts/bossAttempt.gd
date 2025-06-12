extends Node3D

@onready var attack_Spawn = $AttackOrigin
@onready var aoe_attack = preload("res://Scenes/aoe_attack.tscn")

var players_in_range: Array[PlayerChar] = []
var player_targeted: PlayerChar
var distance_to_target: float

func _ready() -> void:
	if not multiplayer.is_server():
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	selecting_current_target()
	if player_targeted:
		look_at(player_targeted.transform.origin, Vector3.UP)


func selecting_current_target():
	if !players_in_range.is_empty():
		for player in players_in_range:
			if !player_targeted:
				player = player_targeted
			elif player.name != player_targeted.name:
				if player.position.distance_to(position) < distance_to_target:
					distance_to_target = player.position.distance_to(position)
					player_targeted = player


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		players_in_range.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		players_in_range.erase(body)
