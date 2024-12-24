extends Node2D

@export var damage: float = 45.0
@export var fire_rate: float = 0.1 # Time in seconds between shots
@export var reload_time: float = 0.5 # Time to reload
@export var magazine_size: int = 20 # Bullets per reload
@export var bullet_speed: float = 2000.0
@export var gun_range: float = 1000.0

var barrel_lenght: float = 80.0 # barrel lenght in pixels, for bullet spawn position offset

var bullets_left: int = magazine_size
var can_shoot: bool = true
var is_reloading: bool = false


func _process(_delta: float) -> void:
	
	var direction = (get_global_mouse_position() - global_position).normalized()
	rotation = direction.angle()

func shoot(target_position: Vector2):

	if can_shoot: # can shoot will only be false when already reloading and when shoot delay time (fire rate) has been passed
		if bullets_left > 0:
			bullets_left -= 1
			emit_signal('shooting', target_position)
			spawn_bullet(target_position)
			# print("pew! bullets left: ", bullets_left)

			# starts the delay between shots (firerate)
			can_shoot = false
			$Timer_Shoot.start(fire_rate)
		else:
			# out of bullets, start reaload
			if not is_reloading:
				# print("mag empty!")
				start_reload()

func start_reload():
	# check for extra errors
	if is_reloading:
		return
	can_shoot = false
	is_reloading = true

	$Timer_Reload.start(reload_time)
	# print("Reloading...")

func finish_reload():
	bullets_left = magazine_size
	can_shoot = true
	is_reloading = false
	# print("Reloaded!")
	# print("bullets left:", bullets_left)

func spawn_bullet(target_position: Vector2):

	var bullet_scene = preload("res://scenes/bullet.tscn")
	var bullet = bullet_scene.instantiate()

	# Spawn the bullet at the gun's barrel position
	var barrel_offset = Vector2(barrel_lenght, 0).rotated(rotation)
	bullet.global_position = self.global_position + barrel_offset

	#pass player position for bullet's origin point
	var player = get_tree().get_root().get_node("GameWorld/Player")
	if player:
		bullet.origin_point = player.global_position
	else:
		print("player not found")

	# Calculate direction from barrel to target position
	var direction = (get_global_mouse_position() - global_position).normalized()
	bullet.direction = (target_position - bullet.global_position).normalized()

	#set properties
	bullet.rotation = direction.angle()
	bullet.damage = damage
	bullet.gun_range = gun_range
	bullet.speed = bullet_speed

	# add bullet to the game
	get_tree().get_root().get_node("GameWorld").add_child(bullet)  # Add directly to the scene tree



func _on_timer_shoot_timeout():
	can_shoot = true


func _on_timer_reload_timeout():
	finish_reload()


# Signals
signal shooting(target_position: Vector2)
