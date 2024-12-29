extends CharacterBody2D
class_name  Entity
@export_category("Motion")
@export var SPEED = 300.0
@export var INERTIA = 100.0
@export var LIMIT=100

func apply_limit(delta)->void:
	var normalizeV= velocity.normalized()
	if abs(velocity.x) > LIMIT :
		velocity.x -= normalizeV.x * SPEED * delta  
	if abs(velocity.y) > LIMIT:
		velocity.y -= normalizeV.y * SPEED * delta
