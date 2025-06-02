extends  Node
class_name bullet_p

@export var pool_size: int
var bullet_scene = preload("res://Scene/Bullet/basic_bullet.tscn")
var is_used: Array[bool]
var bullet_pool :Array

func _ready():
	for i in range(pool_size):
		var temp_bullet = bullet_scene.instantiate()
		bullet_pool.append(temp_bullet)
		bullet_pool[i].pool_index = i
		bullet_pool[i].hide()
		add_child(bullet_pool[i])
		is_used.append(false)
	
func get_bullet():
	var index = is_used.find(true)
	if index != -1:
		is_used[index] = true
		bullet_pool[index].visible = true
		return bullet_pool[index]
	print("INCREASING POOL SIZE")
	pool_size+= 1
	var temp_bullet = bullet_scene.instantiate()
	bullet_pool.append(temp_bullet)
	temp_bullet.pool_index = pool_size-1 
	temp_bullet.hide()
	add_child(temp_bullet)
	temp_bullet.visible = true
	is_used.append(true) 
	return temp_bullet

func reset_bullet(target_bullet):
	target_bullet.position = Vector2(-1000,-1000)
	target_bullet.velocity = 0
	target_bullet.hide()
	is_used[target_bullet.pool_index] = false
