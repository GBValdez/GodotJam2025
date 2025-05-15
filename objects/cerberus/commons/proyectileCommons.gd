extends Entity
class_name  Proyectile
@onready var detectOutside:VisibleOnScreenNotifier2D= $VisibleOnScreenNotifier2D
@onready var particles:GPUParticles2D=$GPUParticles2D

@export() var timeLive:float = 2
func _ready() -> void:
	detectOutside.connect("screen_exited",queue_free)
	if timeLive!=0:
		General.createTimer(timeLive,dead)
	_ready_help()	
func _ready_help():
	pass
		
func dead():
	queue_free()
	
func onDead():
	pass
func motion(delta:float):
	velocity += direction * SPEED*delta	
	apply_inertia(delta,direction)
	apply_limit(delta) 
	move_and_slide()

func _physics_process(delta: float) -> void:
	motion(delta)
