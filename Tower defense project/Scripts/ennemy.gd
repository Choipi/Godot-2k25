extends CharacterBody3D


@export var speed:= 2
@export var health:= 15

@onready var Path: PathFollow3D = get_parent()

func _ready():
	$health_bar.set_up(health)

func _physics_process(delta):
	Path.set_progress(Path.get_progress() + speed * delta)
	
	if Path.get_progress_ratio() >= 0.99:
		Global.player_health -= health
		destroy(Path)
func take_damage(damage_taken):
	$health_bar.decrease_value(damage_taken)
	health -= damage_taken
	if health <= 0:
		Global.money+= 100
		destroy(Path)

func destroy(entity):
	Global.ennemies_alive -= 1
	entity.queue_free()
