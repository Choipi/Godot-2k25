extends Node2D

@export var spawn_count: int = 200
var star_scene = preload("res://star.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in spawn_count:
		var star = star_scene.instantiate()
		add_child(star)
		star.position.x = randi_range(-500,500)
		star.position.y = randi_range(-500,500)
		var star_size = randf_range(0.5, 1.5)
		star.scale *= star_size
