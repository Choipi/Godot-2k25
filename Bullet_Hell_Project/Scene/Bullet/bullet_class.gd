extends CharacterBody2D
class_name bullet

var bullet_damage:int
var bullet_speed:int
var pool_index:int 
var direction : Vector2

func _ready():
	add_to_group("Bullet")
	direction = Vector2.ZERO

func _process(delta):
	self.rotation += 1
	

func _on_hitbox_body_entered(body):
	if body.is_in_group("Ennemy"):
		body.take_damage()

