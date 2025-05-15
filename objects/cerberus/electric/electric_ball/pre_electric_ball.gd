extends CharacterBody2D

func _on_timer_timeout() -> void:
	var bulletScene = load("res://objects/cerberus/electric/electric_ball/electric_ball.tscn").instantiate()
	var parent = get_parent()
	if parent:
		bulletScene.global_position = global_position
		bulletScene.global_rotation = global_rotation

		parent.add_child(bulletScene)
		queue_free()
