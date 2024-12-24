extends Node2D

@export var night_duration := 15 * 60  # 15 minutes in seconds
@export var initial_day := 1

var is_night := false
var day_count := initial_day
var night_timer := 0.0

signal day_started
signal night_started
signal night_ended

func _ready():
	start_day()

func start_day():
	is_night = false
	print("Day started: Day", day_count)
	emit_signal("day_started", day_count)
	# any additional logic for daytime goes here.

func start_night():
	is_night = true
	print("Night started!")
	night_timer = 0.0
	emit_signal("night_started")

func end_night():
	print("Night ended!")
	emit_signal("night_ended")
	day_count += 1
	start_day()

func _process(delta):
	if is_night:
		night_timer += delta
		if night_timer >= night_duration:
			end_night()
