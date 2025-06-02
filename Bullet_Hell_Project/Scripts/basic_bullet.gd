extends bullet

var bullet_pool: bullet_p


func _ready():
	super._ready()
	bullet_damage = 1
	bullet_speed = 230

func _process(delta):
	if visible:
		self.rotation += 1
		position += direction * bullet_speed * delta

func _on_hitbox_body_entered(body):
	if body.is_in_group("Ennemy"):
		body.take_damage(bullet_damage)

func _on_life_time_timeout():
	bullet_pool.reset_bullet(self)
