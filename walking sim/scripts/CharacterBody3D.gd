class_name PlayerController
extends CharacterBody3D

@export_group("Movement")
@export var max_speed:= 4.0
@export var acceleration:= 20.0
@export var braking:= 20.0
@export var air_acceleration:= 4.0
@export var jump_force:= 5.0
@export var gravity_modifier:= 1.5
@export var max_run_speed:= 6.0
var is_running := false

@export_group("Camera")
@export var look_sens:= 0.005
var camera_look_input: Vector2

@onready var camera:= get_node("Camera3D")
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity* delta 
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	var move_input = Input.get_vector("move_left","move_right","move_forward","move_back")
	var move_dir = (transform.basis * Vector3(move_input.x, 0, move_input.z))
	
	is_running = Input.is_action_pressed("sprint")
	
	var target_speed = max_speed
	if is_running:
		target_speed = max_run_speed
		var runc_dot = -move_dir.dot(transform.basis.z)
		runc_dot = clamp(runc_dot,0,1)
		move_dir *= runc_dot
	
	var current_smoothing = acceleration
	
	if not is_on_floor():
		current_smoothing = air_acceleration
	elif not move_dir:
		current_smoothing = braking
	
	var target_vel = move_dir * target_speed
	
	velocity.x = lerp(velocity.x,target_vel.x, current_smoothing*delta)
	velocity.z =lerp(velocity.z,target_vel.z, current_smoothing*delta)
	move_and_slide()
	
	rotate_y(-camera_look_input.x * look_sens)
	camera.rotate_x(-camera_look_input.y * look_sens)
	camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)
	camera_look_input = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera_look_input = event.relative
