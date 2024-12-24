extends Node2D

@export var speed: float = 200.0
@export var max_health: float = 100.0
@export var current_health: float = max_health
@export var collision_damage: float = 0.0
@export var iframe_duration: float = 1.0 # i-frame duration in seconds

@export var exp_points: float = 0
@export var level: int = 1
@export var exp_needed: float = 50

var is_invincible: bool = false

var touching_enemies: Array = []

func _process(delta: float):

	#movement
	var input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	position += input * speed * delta

	# check if at least one enemy is inside player and if so they will take damage
	check_for_enemies(touching_enemies)

	#check for levelups
	levelup()



func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var gun = $Gun
		gun.shoot(get_global_mouse_position())


func levelup():
	if exp_points >= exp_needed:
		level += 1
		print("Level up! You are now level ", level)
	exp_needed = 76 - 51.428 * level + 38.57143 * level * level  # exponential increase in exp needed to level up



func check_for_enemies(enemies_inside_player: Array):

	if enemies_inside_player.size() > 0 and not is_invincible:
		for enemy_area in enemies_inside_player:
			var enemy_node = enemy_area.get_parent()
			if enemy_node:
				take_damage(enemy_node.collision_damage)

func take_damage(amount: float):
	current_health -= amount
	# print("Player health:", current_health)
	if current_health <= 0:
		die()
	else:
		start_invincibility()

func start_invincibility():
	is_invincible = true
	$Timer_iframes.start(iframe_duration)  # Start the i-frame timer

func _on_timer_timeout():
	is_invincible = false
	# print("iframes ended")


func die():
	print("you died, looser")
	queue_free()

func _on_collision_area_area_entered(area: Area2D):
	if area.is_in_group("enemies") and not touching_enemies.has(area):
		touching_enemies.append(area)
		# print("AAAHHHH!")
		print(area)


func _on_collision_area_area_exited(area: Area2D):
	if area.is_in_group("enemies") and touching_enemies.has(area):
		touching_enemies.erase(area)
		# print("enemy exited the player collision", area)
