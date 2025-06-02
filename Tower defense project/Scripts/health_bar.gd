extends ProgressBar


func setup_bar(amount:int):
	max_value = amount
	value = amount

func decrease_value(amount:int):
	value -= amount
