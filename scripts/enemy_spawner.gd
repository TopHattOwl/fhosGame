extends Node2D

var day_count: float = 1
var night_time_duration: float = 15 * 60  # 15 minutes
var night_time_elapsed: float = 0
var spawn_rate_multiplier: float = 1.0
var base_spawn_rate: float = 1.0
var max_spawn_rate: float = 5
var enemy_spawn_timer: float = 0

var midnight_passed: bool = false

var max_enemy_count: int = 0

var enemy_scene = preload("res://scenes/enemy.tscn")

func _ready():
	pass

func _process(delta):

	if night_time_elapsed < night_time_duration:
		night_time_elapsed += delta
		spawn_rate_multiplier = 1 + (night_time_elapsed / night_time_duration) * (max_spawn_rate - 1)
		var effective_spawn_rate = base_spawn_rate * spawn_rate_multiplier
		enemy_spawn_timer += delta
		if enemy_spawn_timer >= 1 / effective_spawn_rate: # also add a check for max number of monsters
			spawn_enemy()
			enemy_spawn_timer = 0
	else:
		# Reset all enemies and reset night_time_elapsed and spawn_rate_multiplier
		night_time_elapsed = 0
		spawn_rate_multiplier = 1
		enemy_spawn_timer = 0

func spawn_enemy():
	# Get player position
	var player = get_tree().get_root().get_node("GameWorld/Player")
	if player:
		var player_position = player.global_position

		# Define the inner and outer circles of the spawn zone
		var inner_circle_radius = 600
		var outer_circle_radius = 1200

		# Generate a random position within the spawn zone
		var angle = randf() * 2 * PI
		var distance = randf() * (outer_circle_radius - inner_circle_radius) + inner_circle_radius
		var spawn_position = player_position + Vector2(cos(angle), sin(angle)) * distance

		# Instantiate the enemy at the spawn position
		var enemy_instance = enemy_scene.instantiate()
		enemy_instance.position = spawn_position
		get_parent().add_child(enemy_instance)
	else:
		print("player not found")

func _on_day_changed():
	day_count += 1
	base_spawn_rate = 1 + (day_count / 10)


#______________________________________________________________________
#new version

# extends Node2D

# @export var base_spawn_rate := 1.0 
# @export var max_spawn_rate := 5.0
# @export var enemy_scene : PackedScene

# var day_count := 1
# var night_time_elapsed := 0.0
# var spawn_rate_multiplier := 1.0
# var enemy_spawn_timer := 0.0
# var midnight_passed := false

# func _ready():
#     var game_world = get_parent()

# func _process(delta):
#     if get_parent().current_state == "night":
#         # Increment elapsed time and adjust spawn rate
#         night_time_elapsed += delta
#         spawn_rate_multiplier = 1 + (night_time_elapsed / get_parent().night_duration) * (max_spawn_rate - 1)
#         var effective_spawn_rate = base_spawn_rate * spawn_rate_multiplier

#         # Check for midnight logic
#         if night_time_elapsed >= 10 * 60 and not midnight_passed:
#             midnight_passed = true
#             print("Midnight reached: Increasing spawn rate multiplier!")

#         # Spawn enemies if the timer exceeds the spawn rate
#         enemy_spawn_timer += delta
#         if enemy_spawn_timer >= 1 / effective_spawn_rate:
#             spawn_enemy()
#             enemy_spawn_timer = 0

# func spawn_enemy():
#     var player = get_tree().get_node("GameWorld/Player")
#     if player:
#         var player_position = player.global_position

#         # Define the spawn zone
#         var inner_circle_radius = 600
#         var outer_circle_radius = 1200
#         var angle = randf() * 2 * PI
#         var distance = randf() * (outer_circle_radius - inner_circle_radius) + inner_circle_radius
#         var spawn_position = player_position + Vector2(cos(angle), sin(angle)) * distance

#         # Instantiate the enemy
#         var enemy_instance = enemy_scene.instantiate()
#         enemy_instance.position = spawn_position
#         add_child(enemy_instance)

# func _on_night_started():
#     # Reset variables for a new night
#     print("Enemy spawner: Night started")
#     night_time_elapsed = 0.0
#     spawn_rate_multiplier = 1.0
#     enemy_spawn_timer = 0.0
#     midnight_passed = false

# func _on_night_ended():
#     print("Enemy spawner: Night ended")
#     # TODO Clear all enemies at the end of the night
#     # for child in get_children():
#     #     if child is Enemy:
#     #         child.queue_free()

# func _on_day_started(new_day_count):
#     day_count = new_day_count
#     base_spawn_rate = 1 + (day_count / 10)
#     print("Day", day_count, "started: Base spawn rate updated to", base_spawn_rate)
