extends Panel

var game_manager
@onready var player_scores_text = $PlayerScores
# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager = get_tree().get_current_scene().get_node("GameManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_scores_text.text = ""
	
	for player in game_manager.players:
		var text = str(player.player_name, " - ", player.score, "\n")
		player_scores_text.text += text
