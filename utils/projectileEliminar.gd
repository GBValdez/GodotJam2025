extends Entity
class_name  ProyectileEliminar
func motion(delta:float):
	velocity += direction * SPEED*delta	
	apply_inertia(delta,direction)
	apply_limit(delta) 
	move_and_slide()

func _physics_process(delta: float) -> void:
	motion(delta)
