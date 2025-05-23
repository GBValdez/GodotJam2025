extends ControllersCommons
var markerSelected:Marker2D=null
var pathSelected:PathFollow2D=null
var dirs:Array[Vector2]=[]
var tornado= preload("res://objects/cerberus/water/tornado/tornado.tscn")
var threes= [preload("res://objects/cerberus/commons/proyectiles/treeBig/treeBig.tscn"),
preload("res://objects/cerberus/commons/proyectiles/treeLitle/treeLitle.tscn")
]
func _ready_help():
	bulletScene=load("res://objects/cerberus/water/balls_water/ball_water.tscn")
	typeAttack=["shotAttack","rebound","attackTornado"]

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
			startAlarms(15,0.2)
			cancerbero.direction=Vector2.ZERO
			if cancerbero.velocity.length()==0:
				cancerbero.sprite.scale.x=-1
				if markerSelected==$maker_left:
					cancerbero.sprite.scale.x=1
				initAttack=false

	else:
		if $timerHelp.is_stopped():
			if dirs.size()==0:
				randomize()
				var degreeRandom:int = randi_range(0,360)
				for i in range(7):
					var radShot:float=deg_to_rad(degreeRandom+i*30)
					var dir:Vector2= Vector2(cos(radShot),sin(radShot))		
					if markerSelected==$maker_left:
						dir.x= abs(dir.x)
					else:
						dir.x= -abs(dir.x)
					dirs.append(dir)
			for dir in dirs:
				cancerbero.dirShot=dir
				var bulletCurret:Proyectile=cancerbero.shot()
				bulletCurret.LIMIT=150
			$timerHelp.start()

func rebound(delta:float):
	if not attack=="rebound":
		return
	if initAttack:
		for i in range(7):
			var radShot:float=deg_to_rad(i*45+10)
			var dir:Vector2= Vector2(cos(radShot),sin(radShot))		
			var bullet=shot(cancerbero.global_position,dir,10)
			bullet.LIMIT=300
			player.INERTIA=0
		randomize()
		var dirTornadoDegree:float= randf_range(0,360)
		var radShot:float=deg_to_rad(dirTornadoDegree)
		var dir:Vector2= Vector2(cos(radShot),sin(radShot))		
		var tornadoCurrent= shotTornado(cancerbero.global_position,dir,10)
		tornadoCurrent.scale.x=2
		tornadoCurrent.scale.y=2
		startAlarms(10,-1)
		initAttack=false
	else:
		var dirPlayer:Vector2=player.global_position-cancerbero.global_position 
		cancerbero.direction=dirPlayer.normalized()

func attackTornado(delta:float):
	if not attack=="attackTornado":
		return
	if initAttack:
		if markerSelected==null:
			randomize()
			markerSelected=$maker_left
			pathSelected=$path_right/PathFollow2D
			if randi_range(0,1)==1:
				markerSelected=$maker_right
				pathSelected= $path_left/PathFollow2D
		var dirPlayer:Vector2=markerSelected.global_position-cancerbero.global_position 
		cancerbero.direction= dirPlayer.normalized() 
		if dirPlayer.length()<20:
			startAlarms(20,0.3)
			cancerbero.direction=Vector2.ZERO
			if cancerbero.velocity.length()==0:
				cancerbero.sprite.scale.x=-1
				if markerSelected==$maker_left:
					cancerbero.sprite.scale.x=1
				initAttack=false
				var tornadoCurrent = shotTornado(cancerbero.global_position,Vector2.ZERO,20)
				tornadoCurrent.scale.x=3
				tornadoCurrent.scale.y=3
				tornadoCurrent.forceAtraction=2000
				player.INERTIA=0
	else:
		if $timerHelp.is_stopped():
			var dir:Vector2= Vector2(0,0)
			if markerSelected==$maker_left:
				dir.x= -1
			else:
				dir.x= 1
			randomize()
			pathSelected.progress_ratio= randf_range(0,1)
			var threeCurrent =shotThree(pathSelected.global_position,dir,20)
			randomize()
			threeCurrent.LIMIT= randf_range(200,400)
			threeCurrent.rotation_degrees= randf_range(0,360)
			$timerHelp.start()


func shotTornado(pos:Vector2,direction:Vector2=Vector2.ZERO,timeShot:float=-1):
	return shotPackage(tornado,pos,direction,timeShot)
	
func shotThree(pos:Vector2,direction:Vector2=Vector2.ZERO,timeShot:float=-1):
	var sceneCurrent= threes.pick_random()
	return shotPackage(sceneCurrent,pos,direction,timeShot)


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
	shotAttack(delta)	
	rebound(delta)
	attackTornado(delta)
	
func _on_timer_end_attack_timeout() -> void:
	var time=6;
	if attack=="shotAttack":
		time=12
	changeAttack(time)
	dirs.clear()
	initAttack=true
	markerSelected=null
	pathSelected=null
	player.INERTIA=5000.0
