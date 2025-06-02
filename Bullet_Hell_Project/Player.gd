extends CharacterBody2D

@onready var bullet_pool: bullet_p = get_node("Bullet_Pool")
@export var speed: float
@export var Anim : AnimatedSprite2D
var can_shoot = true
@export var Basic_bullet_fire_rate: Timer


func _physics_process(delta):
	handle_movement_input(delta)
	shoot()

func handle_movement_input(delta):
	var mov_dir = Vector2.ZERO
	if Input.is_action_pressed("left"):
		mov_dir += Vector2.LEFT
		Anim.flip_h = true
		Anim.play("side")
	if Input.is_action_pressed("right"):
		mov_dir += Vector2.RIGHT
		Anim.flip_h = false
		Anim.play("side")
	if Input.is_action_pressed("up"):
		mov_dir += Vector2.UP
		Anim.play("up")
	if Input.is_action_pressed("down"):
		mov_dir += Vector2.DOWN
		Anim.play("down")
	
	position += mov_dir * delta * speed
	$bullet_spawn_point.position = global_position + mov_dir*5

func shoot():
	if can_shoot:
		can_shoot = false
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		var temp_bullet = bullet_pool.get_bullet()
		temp_bullet.direction = direction  
		temp_bullet.bullet_pool = bullet_pool
		temp_bullet.position = $bullet_spawn_point.position


func _on_fire_rate_timeout():
	can_shoot = true
