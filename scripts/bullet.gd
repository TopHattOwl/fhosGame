extends Node2D

@export var damage: float = 20.0
@export var speed: float = 500.0 # base values, the gun overwrites these (damage, speed)
@export var gun_range: float = 200.0

var origin_point

var direction: Vector2

# func _ready() -> void:

# 	print("bullet is ready!")
# 	print("gameworld childeren:", get_tree().get_root().get_node("GameWorld").get_children())
# 	var player = get_tree().get_root().get_node("GameWorld/Player")

# 	if player:
# 		print("player found!")
# 		var origin_point = player.global_position
# 	else:
# 		print("player is not found")

	


func _process(delta: float):


	# moving the bullets
	position += direction * speed * delta

	#debug
	# print("bullet position: ", position)
	# print("distance from player: ", position.distance_to(player_position))

	if position.distance_to(origin_point) > gun_range:
		queue_free()


func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("enemies"):
		#remove the bullet from the scene
		queue_free()

		# damage the enemy
		var enemy = area.get_parent()
		if enemy and enemy.has_method("take_damage"):
			enemy.take_damage(damage)

		# print("hit!")

		
