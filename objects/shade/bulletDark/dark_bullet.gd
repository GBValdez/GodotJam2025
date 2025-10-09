extends PathFollow2D
class_name platform
@export_category("motion")
@export var speed: float = 100.0
@export var returnPlat: bool = false
@export var keepTime: float =0
@export var waitExtreme:bool=false
		
func _physics_process(delta):
	if(!waitExtreme):
		progress += speed * delta
		if (returnPlat):
			if progress_ratio == 1.0 or progress_ratio == 0.0:
				if(keepTime!=0 and !waitExtreme):
					waitExtreme=true
					General.createTimer(keepTime,endWait)
				if(keepTime==0):
					speed = -speed	
func endWait():
	waitExtreme=false
	speed = -speed	
