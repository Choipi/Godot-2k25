extends Sprite3D

@onready var bar : ProgressBar=$SubViewport/health_bar

func _ready():
	texture = $SubViewport.get_texture()

func set_up(value:int):
	bar.setup_bar(value)

func decrease_value(value:int):
	bar.decrease_value(value)
