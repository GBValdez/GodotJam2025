extends Entity
class_name  Proyectile
@onready var detectOutside:VisibleOnScreenNotifier2D= $VisibleOnScreenNotifier2D
func _ready() -> void:
	detectOutside.connect("screen_exited",queue_free)

func motion(delta:float):
	velocity += direction * SPEED*delta	
	apply_inertia(delta,direction)
	apply_limit(delta) 
	move_and_slide()

func _physics_process(delta: float) -> void:
	motion(delta)
