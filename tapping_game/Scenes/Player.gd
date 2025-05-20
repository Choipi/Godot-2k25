extends RigidBody2D


var impulse_force: int = 1200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("space"):
		apply_central_impulse(Vector2.UP + Vector2(0,-impulse_force))
