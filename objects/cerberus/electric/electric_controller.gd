extends ControllersCommons
@onready() var pathFollow=$pathFire/pathFollowFire
var angleCross:float=0
var rayBullet=preload("res://objects/cerberus/electric/electric_ball/ray.tscn")
var laserBuller= preload("res://objects/cerberus/electric/laser/laser.tscn")
func _ready_help():
	bulletScene=load("res://objects/cerberus/electric/electric_ball/electric_ball.tscn")
	typeAttack=["ray","laser"]

func rayAttack(delta:float):
	if not attack=="ray":
		return
	if initAttack:
		initAttack=false
		startAlarms(10,1)
	else:
		if $timerHelp.is_stopped():
			randomize()
			var POS_INIT :Array[Vector2]=[]
			var PLAYER_POS:Vector2= Vector2(floor(player.global_position.x/32)*32,floor(player.global_position.y/32)*32) 
			cancerbero.playSound("audioRay")
			shotPackage(rayBullet,PLAYER_POS)
			for i in range(110):
				var randomPos:Vector2= Vector2.ZERO
				var no_exist:bool=false
				while  not no_exist:
					randomPos=Vector2(randi_range(0,18),randi_range(0,11))
					no_exist=true
					for pos in POS_INIT:
						if pos==randomPos:
							no_exist=false
				randomPos*=32
				shotPackage(rayBullet,randomPos)
			$timerHelp.start()

func laserAttack(delta:float):
	if not attack=="laser":
		return
	if initAttack:
		initAttack=false
		startAlarms(10,1.2)
		shotLaser()
	else:
		if $timerHelp.is_stopped():
			shotLaser()
			$timerHelp.start()
			
func shotLaser():
	randomize()
	var numShot=randi_range(1,5)
	for i in range(numShot):
		randomize()
		var posRandom:Vector2=Vector2(randi_range(0,324*1.5),randi_range(32,200))
		var bulletCurrent= General.addNode(laserBuller,posRandom)
		var size:float=randf_range(0.5,2)
		bulletCurrent.scale=Vector2(size,size)
		bulletCurrent.shotPlayer()
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
	rayAttack(delta)
	laserAttack(delta)

func _on_timer_end_attack_timeout() -> void:
	changeAttack()
	pass # Replace with function body.
