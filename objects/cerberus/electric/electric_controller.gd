extends ControllersCommons
@onready() var pathFollow=$pathFire/pathFollowFire
var angleCross:float=0
var rayBullet=preload("res://objects/cerberus/electric/electric_ball/ray.tscn")
var laserBuller= preload("res://objects/cerberus/electric/laser/laser.tscn")
var ray_wave_active:bool=false

const ANDROID_RAY_BASE_COUNT := 28
const ANDROID_RAY_BATCH_SIZE := 8
const ANDROID_RAY_BATCH_DELAY := 0.045

func _ready_help():
	bulletScene=load("res://objects/cerberus/electric/electric_ball/electric_ball.tscn")
	typeAttack=["ray","laser"]

func rayAttack(delta:float):
	if not attack=="ray":
		return
	if initAttack:
		initAttack=false
		startAlarms(10,1.45)
	else:
		if $timerHelp.is_stopped() and not ray_wave_active:
			spawn_ray_wave()
			$timerHelp.start()

func spawn_ray_wave() -> void:
	ray_wave_active=true
	randomize()
	var positions:Array[Vector2]=[]
	var PLAYER_POS:Vector2= Vector2(floor(player.global_position.x/32)*32,floor(player.global_position.y/32)*32)
	positions.append(PLAYER_POS)
	var target_count := min(harder_count(ANDROID_RAY_BASE_COUNT), 48)
	while positions.size() < target_count:
		var randomPos:Vector2=Vector2(randi_range(0,18),randi_range(0,11))*32
		if not positions.has(randomPos):
			positions.append(randomPos)
	cancerbero.playSound("audioRay")
	var spawned := 0
	for pos in positions:
		shotPackage(rayBullet,pos)
		spawned += 1
		if spawned % ANDROID_RAY_BATCH_SIZE == 0:
			await get_tree().create_timer(ANDROID_RAY_BATCH_DELAY).timeout
	ray_wave_active=false

func laserAttack(delta:float):
	if not attack=="laser":
		return
	if initAttack:
		initAttack=false
		startAlarms(10,1.6)
		shotLaser()
	else:
		if $timerHelp.is_stopped():
			shotLaser()
			$timerHelp.start()
			
func shotLaser():
	randomize()
	var numShot=randi_range(1,min(harder_count(3),4))
	for i in range(numShot):
		randomize()
		var posRandom:Vector2=Vector2(randi_range(0,324*1.5),randi_range(32,200))
		var bulletCurrent= General.addNode(laserBuller,posRandom)
		var size:float=randf_range(0.5,1.65)
		bulletCurrent.scale=Vector2(size,size)
		bulletCurrent.force=harder_stat(bulletCurrent.force)
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