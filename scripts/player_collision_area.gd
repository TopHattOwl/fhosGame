extends Area2D


func _on_body_entered(body):
	print("DEBUG: Collision detected with:", body.name)
