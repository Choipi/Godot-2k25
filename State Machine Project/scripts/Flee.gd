extends State

@export var max_flee_distance_from_player := 10.0
var opposite_player_direction: Vector3
var time_between_updates:= 1.0
var last_time_path_updated: float

func enter():
	super.enter()
	controller.is_running = true
	controller.look_at_player = false
	opposite_player_direction =(controller.position - controller.player.position).normalized()
	controller.move_to_position(opposite_player_direction + controller.position*5)
func exit():
	super.exit()
	controller.is_running = false

func update(delta):
	if controller.player_distance > max_flee_distance_from_player:
		state_machine.change_state("Wander")
	
func navigation_complete():
	opposite_player_direction =(controller.position - controller.player.position).normalized()
	controller.move_to_position(opposite_player_direction + controller.position*5)


