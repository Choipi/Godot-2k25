extends MultiplayerSynchronizer

@export var throttle_input : float
@export var tunr_input : float
@export var shoot_input : float

func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_physics_process(false)

func _physics_process(delta):
	throttle_input = Input.get_axis("throttle_down", "throttle_up")
	tunr_input = Input.get_axis("throttle_left", "throttle_right")
	shoot_input = Input.is_action_pressed("shoot")
