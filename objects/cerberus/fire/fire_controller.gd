extends ControllersCommons
@onready() var pathFollow=$pathFire/pathFollowFire
var angleCross:float=0

func _ready_help():
	bulletScene=load("res://objects/cerberus/fire/balls_fire/ball_fire.tscn")
	typeAttack=["assault","side","cross"]


func assault(delta:float):
	if not attack=="assault":
		return
	var dirPlayer:Vector2=player.global_position-cancerbero.global_position 
	if initAttack:
		cancerbero.SPEED=1000
		cancerbero.INERTIA=1200
		cancerbero.SPEED_LIMIT=1500
		cancerbero.LIMIT=600
		cancerbero.direction= dirPlayer.normalized() 
		initAttack=false
		currentNumAttack+=1
		$timerAssoult.wait_time=1
		$timerAssoult.start()
		generateNumAttacks(3,5)
	else:
		shotWithTimeCerbero()
		if $timerAssoult.is_stopped():
			cancerbero.direction= dirPlayer.normalized() 
			currentNumAttack+=1
			$timerAssoult.start()
			cancerbero.velocity=Vector2.ZERO
			if currentNumAttack>numAttacks:
				changeAttack()
				cancerbero.direction=Vector2.ZERO

func side(delta:float):
	if not attack=="side":
		return
	if initAttack:
		$pathFire/pathFollowNormalFire.progress_ratio+=delta*0.4
		shotWithTime($pathFire/pathFollowNormalFire.global_position,Vector2.ZERO,10)
		if $pathFire/pathFollowNormalFire.progress_ratio>0.9:
					$timerAssoult.wait_time=0.1
					initAttack=false
					generateNumAttacks(40,50)
		
	else:
		$pathFire/pathFollowNormalFire.progress+=delta*300
		shotWithTime($pathFire/pathFollowNormalFire.global_position,Vector2.ZERO,10)
		if $timerAssoult.is_stopped():
			pathFollow.progress_ratio= randf_range(0,1)	
			var dirPlayer:Vector2=player.global_position-pathFollow.global_position 
			shot(pathFollow.global_position,dirPlayer.normalized(),10) 
			$timerAssoult.start()
			currentNumAttack+=1
			if currentNumAttack>numAttacks:
				changeAttack()

func cross(delta:float):
	if not attack=="cross":
		return
	if initAttack:
		initAttack=false
		$timerAssoult.wait_time=0.4
		generateNumAttacks(10,20)
		$timerCross.wait_time=numAttacks
		$timerCross.start()
		
	else:
		if $timerAssoult.is_stopped():
			for i in range(0, 361, 30):  # Empieza en 0, llega hasta 360, sumando de 10 en 10
				var rad= deg_to_rad(i+angleCross)
				var dir:Vector2 = Vector2(cos(rad),sin(rad))* 10
				var posInitial=cancerbero.global_position+ dir.normalized()*30
				
				shot(posInitial,dir.normalized(),10) 
			$timerAssoult.start()
			angleCross+=70
			

func _physics_process(delta: float) -> void:
	if not canInitAttack:
		return
	assault(delta)	
	side(delta)
	cross(delta)


func _on_timer_cross_timeout() -> void:
	changeAttack()
