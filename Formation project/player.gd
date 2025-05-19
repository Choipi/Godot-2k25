extends CharacterBody3D

func _ready():
	global_position = Vector3(0,0,)

func _physics_process(delta):
	velocity = Vector3(0,0,0)
	
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x -= 1
	
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.z += 1
		
	if Input.is_key_pressed(KEY_UP):
		velocity.z -= 1
		
	if Input.is_key_pressed(KEY_DOWN):
		velocity.z += 1
	velocity*= 50 * delta
	move_and_slide()
