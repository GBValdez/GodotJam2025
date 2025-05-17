extends Node2D
class_name ControllersCommons
@onready() var  cancerbero:CancerBerusCommons=$cancerbero
@onready() var shotTimer:Timer= $shotTimer
@onready() var shotTimerCancerbero:Timer=$shotTimerCancerbero
@onready() var tEndAttack:Timer= $timerEndAttack
@onready() var tTimerHelp:Timer=$timerHelp
var bulletScene
var player:Player
var attack:String=""
var typeAttack:Array[String]=[]
var initAttack: bool=true

var canInitAttack:bool=false
var shockWake:ColorRect
var initFight:bool=true
func _ready() -> void:
	player=get_tree().get_first_node_in_group("player")
	shockWake= get_tree().get_first_node_in_group("shockWave")
	_ready_help()
	cancerbero.get_node("CollisionShape2D").disabled=true
	

func apparecing():
	if initFight:
		var dirs:Vector2=Vector2(300,30)- cancerbero.global_position
		cancerbero.direction=dirs.normalized()
		if dirs.length()<20:
			initFight=false
			changeAttack()
			cancerbero.get_node("CollisionShape2D").disabled=false
			cancerbero.direction=Vector2.ZERO
		
func deapparecing():
	if cancerbero.health==0:
		cancerbero.get_node("CollisionShape2D").disabled=true
		var dirPlayer:Vector2=cancerbero.global_position-Vector2(300,150) 
		cancerbero.direction=dirPlayer.normalized()
		if dirPlayer.length()>500:
			queue_free()
			General.fase+=1
func _ready_help():
	pass

func shot(pos:Vector2,direction:Vector2=Vector2.ZERO,timeShot:float=-1):
	cancerbero.playSound("audioElement")
	return shotPackage(bulletScene,pos,direction,timeShot)

func shotPackage(package,pos:Vector2,direction:Vector2=Vector2.ZERO,timeShot:float=-1):
	var bulletCurrent:Proyectile=package.instantiate()
	bulletCurrent.global_position=pos
	bulletCurrent.direction=direction
	if timeShot!=-1:
		bulletCurrent.timeLive=timeShot
	var level= get_tree().get_first_node_in_group("level")
	level.add_child(bulletCurrent)
	return bulletCurrent
	
func shotWithTime(pos:Vector2,direction:Vector2=Vector2.ZERO,timeShot:float=-1):
	if not shotTimer.is_stopped():
		return
	shot(pos,direction,timeShot)
	shotTimer.start()

func shotWithTimeCerbero(direction:Vector2=Vector2.ZERO):
	if not shotTimerCancerbero.is_stopped():
		return
	cancerbero.dirShot=direction
	cancerbero.shot()
	shotTimerCancerbero.start()

func changeAttack(wait:float=6):
	attack= typeAttack.pick_random()
	initAttack=true
	General.createTimer(wait-1.5,alertAttack)
	General.createTimer(wait,activateAttack)
	canInitAttack=false
func  alertAttack():
	cancerbero.playSound("audioBark",1,1.2)
	var pos= cancerbero.global_position
	var camera = get_viewport().get_camera_2d()
	var viewport_size = get_viewport().get_visible_rect().size
	var origin= cancerbero.global_position/ viewport_size
	shockWake.visible=true
	var shaderMat:ShaderMaterial= shockWake.material
	shaderMat.set_shader_parameter("center",origin)
	var tween = create_tween()
	tween.tween_method(set_shader_value, 0.0, 5.0, 3);


func set_shader_value(value: float):
	var shaderMat:ShaderMaterial= shockWake.material
	shaderMat.set_shader_parameter("radius",value)
	
func startAlarms(endAttack:float,help:float):
	if(endAttack!=-1):
		tEndAttack.wait_time= endAttack
		tEndAttack.start()
	if(help!=-1):
		tTimerHelp.wait_time=help
		tTimerHelp.start()	


func activateAttack():
	canInitAttack=true
	shockWake.visible=false
	

func stopSound():
	if get_tree().get_node_count_in_group("proyectile")==0:
		cancerbero.stopSound("audioElement")
