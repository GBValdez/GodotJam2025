extends CharacterBody2D
class_name  Entity
@export_category("Motion")
@export var SPEED = 300.0
@export var INERTIA = 100.0
@export var LIMIT=100
@export var SPEED_LIMIT= 300.0;
func apply_limit(delta)->void:
	var normalizeV= velocity.normalized()
	var limitNormalize= normalizeV * LIMIT
	if abs(velocity.x) > abs(limitNormalize.x) :
		velocity.x -= normalizeV.x * SPEED_LIMIT * delta  
	if abs(velocity.y) > abs(limitNormalize.y):
		velocity.y -= normalizeV.y * SPEED_LIMIT * delta
