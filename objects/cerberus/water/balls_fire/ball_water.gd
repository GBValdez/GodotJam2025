extends Proyectile
func _physics_process(delta: float) -> void:
	motion(delta)
	if velocity.x==0:
		direction.x*=-1
	if velocity.y==0:
		direction.y*=-1
