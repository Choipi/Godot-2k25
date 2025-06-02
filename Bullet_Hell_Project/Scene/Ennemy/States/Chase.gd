extends State

func enter():
	super.enter()
	controller.can_move = true

func exit():
	super.exit()

func update(delta):
	print(controller.player_distance)
	if controller.player_distance < controller.attack_range:
		state_machine.change_state("Attack")

