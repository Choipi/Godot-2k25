extends State


func enter():
	super.enter()
	controller.can_move = false
	controller.is_attacking = true
	controller.attack()
	
func exit():
	super.exit()

func update(delta):
	if !controller.is_attacking and controller.player_distance > controller.attack_range:
		state_machine.change_state("Chase")


