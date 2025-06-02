extends Node3D

@onready var enemy: PackedScene = preload("res://Mobs/UFO.tscn")
@onready var cannon: PackedScene = preload("res://Turrets/cannon.tscn")
@onready var green_material = preload("res://Materials/green_indicator.tres")
@onready var red_material = preload("res://Materials/red_indicator.tres") 
@onready var indicator = $Indicator
@onready var cam = $Camera3D
var build_menu_open := false

var ennemies_to_spawn:= 3

var can_spawn:= false

var wave_on_going := false


func _process(delta):
	game_manager()
	handle_ui()
	handle_player_input()

func game_manager():
	if ennemies_to_spawn > 0 and can_spawn:
		$Timer.start()
		
		var temp = enemy.instantiate()
		$Path.add_child(temp)
		
		ennemies_to_spawn -=1
		Global.ennemies_alive +=1
		can_spawn = false
		
	wave_on_going = true if Global.ennemies_alive>0 else false

func _on_timer_timeout():
	can_spawn = true

func handle_player_input():
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var origin = cam.project_ray_origin(mouse_pos)
	var end = origin + cam.project_ray_normal(mouse_pos) * 100
	var ray: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin,end)
	ray.collide_with_bodies = true
	
	var result = space_state.intersect_ray(ray)
	if !build_menu_open:
		if result.size()>0:
			indicator.visible = true
			var collider: CollisionObject3D = result.get("collider")
			indicator.global_position = collider.global_position
			if collider.is_in_group("buildable_tile"):
				indicator.set_surface_override_material(0,green_material)

				if Input.is_action_just_pressed("interact")  :
					build_menu_open = true
			else:
				indicator.set_surface_override_material(0,red_material)
		else:
			indicator.visible = false


func handle_ui():
	$CanvasLayer/UI/ShopPanel.visible = build_menu_open
	$CanvasLayer/UI/Money.text = str( Global.money) + " Golds"
	$"CanvasLayer/UI/Next Wave".visible = !wave_on_going
func buy_tower(cost:int, tower):
	if Global.money >=  cost:
		build_menu_open = false
		Global.money -= cost
		var temp_canon = tower.instantiate()
		add_child(temp_canon)
		temp_canon.global_position = indicator.global_position + Vector3(0,0.2,0)

func _on_cannon_button_pressed():
	buy_tower(250,cannon)


func _on_cancel_button_pressed():
	build_menu_open= false


func _on_next_wave_pressed():
	Global.wave += 1
	ennemies_to_spawn =3 * Global.wave
	can_spawn = true
	wave_on_going = true
