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
		cancerbero.SPEED=1500
		cancerbero.INERTIA=1200
		cancerbero.SPEED_LIMIT=1500
		cancerbero.LIMIT=700
		cancerbero.direction= dirPlayer.normalized() 
		initAttack=false
		startAlarms(10,1)
	else:
		shotWithTimeCerbero()
		if $timerHelp.is_stopped():
			cancerbero.direction= dirPlayer.normalized() 
			$timerHelp.start()
			cancerbero.velocity=Vector2.ZERO
			

func side(delta:float):
	if not attack=="side":
		return
	if initAttack:
		$pathFire/pathFollowNormalFire.progress_ratio+=delta*0.4
		shotWithTime($pathFire/pathFollowNormalFire.global_position,Vector2.ZERO,10)
		if $pathFire/pathFollowNormalFire.progress_ratio>0.9:
					initAttack=false
					startAlarms(10,0.2)
		
	else:
		$pathFire/pathFollowNormalFire.progress+=delta*300
		shotWithTime($pathFire/pathFollowNormalFire.global_position,Vector2.ZERO,10)
		if $timerHelp.is_stopped():
			pathFollow.progress_ratio= randf_range(0,1)	
			var dirPlayer:Vector2=player.global_position-pathFollow.global_position 
			shot(pathFollow.global_position,dirPlayer.normalized(),10) 
			$timerHelp.start()

func cross(delta:float):
	if not attack=="cross":
		return
	if initAttack:
		initAttack=false
		startAlarms(10,0.5)
		angleCross=0
		cancerbero.SPEED=30
		cancerbero.INERTIA=70
		cancerbero.SPEED_LIMIT=80
		cancerbero.LIMIT=20
	else:
		var dirPlayer:Vector2=player.global_position-cancerbero.global_position 
		cancerbero.direction.x=dirPlayer.normalized().x
		cancerbero.direction.y=-dirPlayer.normalized().y
		if $timerHelp.is_stopped():
			for i in range(0, 361, 30):  # Empieza en 0, llega hasta 360, sumando de 10 en 10
				var rad= deg_to_rad(i+angleCross)
				var dir:Vector2 = Vector2(cos(rad),sin(rad))* 10
				var posInitial=cancerbero.global_position+ dir.normalized()*30
				
				shot(posInitial,dir.normalized(),10) 
			$timerHelp.start()
			angleCross+=10
			

func _physics_process(delta: float) -> void:
	stopSound()
	apparecing()
	deapparecing()
	if cancerbero.health==0:
		return
	if initFight:
		return
	if not canInitAttack:
		return
	assault(delta)	
	side(delta)
	cross(delta)
	


func _on_timer_cross_timeout() -> void:
	changeAttack()
	cancerbero.direction=Vector2.ZERO
