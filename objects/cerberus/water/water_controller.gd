extends ControllersCommons
var markerSelected:Marker2D=null
var dirs:Array[Vector2]=[]
func _ready_help():
	bulletScene=load("res://objects/cerberus/water/balls_fire/ball_water.tscn")
	typeAttack=["shotAttack","rebound",""]
	typeAttack=["shotAttack"]


func shotAttack(delta:float):
	if not attack=="shotAttack":
		return
	if initAttack:
		if markerSelected==null:
			randomize()
			markerSelected=$maker_left
			if randi_range(0,1)==1:
				markerSelected=$maker_right
		var dirPlayer:Vector2=markerSelected.global_position-cancerbero.global_position 
		cancerbero.direction= dirPlayer.normalized() 
		if dirPlayer.length()<20:
			$timerHelp.wait_time=0.2
			$timerHelp.start()
			$timerEndAttack.start()
			cancerbero.direction=Vector2.ZERO
			if cancerbero.velocity.length()==0:
				cancerbero.sprite.scale.x=-1
				if markerSelected==$maker_left:
					cancerbero.sprite.scale.x=1
				generateNumAttacks(3,5)
				initAttack=false

	else:
		if $timerHelp.is_stopped():
			if dirs.size()==0:
				randomize()
				var degreeRandom:int = randi_range(0,360)
				for i in range(7):
					var radShot:float=deg_to_rad(degreeRandom+i*30)
					var dir:Vector2= Vector2(cos(radShot),sin(radShot))		
					print(dir)
					print(radShot)
					if markerSelected==$maker_left:
						dir.x= abs(dir.x)
					else:
						dir.x= -abs(dir.x)
					dirs.append(dir)
				print(dirs)
			for dir in dirs:
				cancerbero.dirShot=dir
				cancerbero.shot()
			$timerHelp.start()

			

func _physics_process(delta: float) -> void:
	if not canInitAttack:
		return
	shotAttack(delta)	
	

	


func _on_timer_end_attack_timeout() -> void:
	changeAttack()
	dirs.clear()
