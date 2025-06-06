extends ProgressBar

@export var fill_color: Gradient
var game_manager
func _ready():
	game_manager= get_tree().get_current_scene().get_node("GameManager")
	var fill_style = get("theme_override_styles/fill")
	if fill_style == null:
		fill_style = StyleBoxFlat.new()
		add_theme_stylebox_override("fill", fill_style)
	
func _process(delta):
	if game_manager.local_player == null:
		return
	var player: Player = game_manager.local_player
	
	max_value = player.max_weapon_heat
	value = player.current_weapon_heat
	get("theme_override_styles/fill").bg_color = fill_color.sample(value/max_value)
	
