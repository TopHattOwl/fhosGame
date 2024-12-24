extends Node2D

@export var speed: float = 100.0
@export var max_health: float = 100.0
@export var current_health: float = max_health
@export var collision_damage: float = 20.0
@export var experience: float = 20.0

var player: Node2D = null

func _ready():
	# Locate the player node in the scene
	player = get_tree().get_root().get_node("GameWorld/Player")

func _process(delta: float):
	# Ensure we have a valid reference to the player
	if player and is_instance_valid(player):
		# Calculate the direction to the player
		var direction = (player.global_position - global_position).normalized()
		# Move the enemy towards the player
		position += direction * speed * delta


func take_damage(amount: float):
	current_health -= amount
	#print("Enemy health:", current_health)
	if current_health <= 0:
		die()


func die():
	player.exp_points += experience
	queue_free()
