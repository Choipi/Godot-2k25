extends CanvasLayer

@onready var player  =$"../CharacterBody2D"
@onready var Generation = $"../Generation"
@onready var grid = load("res://Scenes/minimap_grid.tscn") 

func _ready():
	generate_minimap()

func _physics_process(delta):
	update_minimap()

func generate_minimap():
	$Minimap/GridContainer.columns = Generation.map_width
	
	for i in range(Generation.map_height):
		for j in range(Generation.map_width):
			var panel = grid.instantiate()
			if !Generation.map[j][i]:
				panel.modulate = "ffffff00"
			else:
				panel.is_room =true
				panel.pos = Vector2i(j,i)
			$Minimap/GridContainer.add_child(panel)

func update_minimap():
	var pos: Vector2i = (player.global_position/ 816)
	var panels = $Minimap/GridContainer.get_children()
	for panel in panels:
		if panel.is_room:
			panel.modulate = "ffffff"
		if panel.pos == pos:
			panel.modulate = "00ffff"
		
