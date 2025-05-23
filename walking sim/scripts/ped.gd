extends InteractableObj

var showing := false

func _interact():
	if showing:
		$light_bulb.hide()
	else:
		$light_bulb.show()
	showing = !showing
