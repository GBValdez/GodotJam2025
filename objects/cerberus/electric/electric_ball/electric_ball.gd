extends Entity
class_name  Electric_proyectile
@onready var detectOutside:VisibleOnScreenNotifier2D= $VisibleOnScreenNotifier2D
@onready var particles:GPUParticles2D=$GPUParticles2D

var timeLive:float = 1
func _ready() -> void:
	detectOutside.connect("screen_exited",queue_free)
	if timeLive!=0:
		General.createTimer(timeLive,dead)
		
func dead():
	particles.emitting=false
	$hitOther/CollisionShape2D.disabled=true
	
	General.createTimer(0.5,queue_free)

func motion(delta:float):
	velocity += direction * SPEED*delta	
	apply_inertia(delta,direction)
	apply_limit(delta) 
	move_and_slide()

func _physics_process(delta: float) -> void:
	motion(delta)
