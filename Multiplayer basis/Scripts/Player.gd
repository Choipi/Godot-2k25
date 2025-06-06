extends CharacterBody2D
class_name  Player

@export var player_name: String
@export var player_id: int = 1:
	set(id):
		player_id = id
		$InputSynchronizer2.set_multiplayer_authority(id)
@export var max_speed: float = 300.0
@export var acceleration: float = 70.0
@export var turn_rate: float = 2.0
var throttle: float = 0.0

@export var fire_rate : float = 0.1
var last_shoot_time: float
var last_attacker_id : int
var projectile_scene = preload("res://Scenes/Projectile.tscn")

@onready var input = $InputSynchronizer2

var border_x :float = 400
var border_y :float = 230

@export var current_hp :int= 100
@export var max_hp :int= 100
@export var score :int= 0
var is_alive : bool = true
@onready var respawn_timer = $RespawnTImer
@onready var audio_player = $AudioStreamPlayer


@export var current_weapon_heat: float = 0.0 
@export var max_weapon_heat: float = 100.0
var weapon_heat_increase_per_shot: float = 7.0
var weapon_heat_cool_rate: float = 25.0
var weapon_heat_cap_wait_time: float = 1.5
var weapon_heat_heat_waiting: bool= false

var shoot_sfx = preload("res://Audio/PlaneShoot.wav")
var hit_sfx = preload("res://Audio/PlaneHit.wav")
var explode_sfx = preload("res://Audio/PlaneExplode.wav")


var game_manager

func _ready():
	game_manager = get_tree().get_current_scene().get_node("GameManager")
	game_manager.players.append(self)
	
	if $InputSynchronizer2.is_multiplayer_authority():
		
		game_manager.local_player = self
		
		var network_m =  get_tree().get_current_scene().get_node("Network")
		set_player_name.rpc(network_m.local_username)
	if multiplayer.is_server():
		position = game_manager.get_random_spawn_pos()
func _process(delta):
	$Shadow.global_position = position + Vector2(0,20)
	
	if multiplayer.is_server():
		check_border()
		_try_shoot()
		manage_weapon_heat(delta)

func _physics_process(delta):
	if multiplayer.is_server() and is_alive:
		_move(delta)

func _move(delta):
	rotate(input.tunr_input* turn_rate * delta)
	throttle += input.throttle_input * delta
	clamp(throttle, -1.0,0.2)
	
	velocity = -transform.y * throttle * acceleration
	move_and_slide()

func check_border():
	if position.x < -border_x:
		position.x = border_x
	
	if position.x > border_x:
		position.x = -border_x
	
	if position.y < -border_y:
		position.y = border_y
	
	if position.y > border_y:
		position.y = -border_y
	

func take_damage(damage_amount:int, attacker_player:int):
	current_hp -= damage_amount
	last_attacker_id = attacker_player
	take_damage_clients()
	
	if current_hp<=0:
		die()

func die():
	is_alive = false
	position = Vector2(999,999)
	respawn_timer.start(2)
	game_manager.on_player_die(player_id,last_attacker_id)
	play_die_sfx()

func respawn():
	is_alive = true
	current_hp = max_hp
	throttle = 0.0
	last_attacker_id = -1
	position = game_manager.get_random_spawn_pos()
	rotation = 0
func _try_shoot():
	if not input.shoot_input:
		return
	if Time.get_unix_time_from_system() -  last_shoot_time < fire_rate:
		return
	if current_weapon_heat>= max_weapon_heat:
		return
	last_shoot_time = Time.get_unix_time_from_system()
	var proj = projectile_scene.instantiate()
	proj.position = $Muzzle.global_position
	proj.rotation = rotation + deg_to_rad(randf_range(-5,5))
	proj.owner_id = player_id
	get_tree().get_current_scene().get_node("Network/SpawnedNodes").add_child(proj, true)
	play_shoot_sfx()
	current_weapon_heat += weapon_heat_increase_per_shot
	current_weapon_heat = clamp(current_weapon_heat,0,max_weapon_heat)
	
func manage_weapon_heat(delta):

	if current_weapon_heat<max_weapon_heat and current_weapon_heat > 0:
		current_weapon_heat -= weapon_heat_cool_rate *delta
		
		if current_weapon_heat < 0:
			current_weapon_heat = 0
		return
	if weapon_heat_heat_waiting:
		return
	weapon_heat_heat_waiting = true
	await get_tree().create_timer(weapon_heat_cap_wait_time).timeout
	weapon_heat_heat_waiting = false
	current_weapon_heat -= weapon_heat_cool_rate* delta

func increase_score(score_increase: int ):
	score += score_increase
@rpc("any_peer","call_local","reliable")
func set_player_name( new_name: String):
	player_name = new_name
@rpc("authority", "call_local", "reliable")
func play_shoot_sfx():
	audio_player.stream = shoot_sfx
	audio_player.play()

@rpc("authority", "call_local", "reliable")
func take_damage_clients():
	audio_player.stream = hit_sfx
	audio_player.play()

@rpc("authority", "call_local", "reliable")
func play_die_sfx():
	audio_player.stream = explode_sfx
	audio_player.play()
