extends Node2D
class_name ControllersCommons
@onready() var  cancerbero:CancerBerusCommons=$cancerbero
@onready() var shotTimer:Timer= $shotTimer
@onready() var shotTimerCancerbero:Timer=$shotTimerCancerbero
var bulletScene
var player:Player
var attack:String=""
var typeAttack:Array[String]=[]
var initAttack: bool=true
var numAttacks:int= 0;
var currentNumAttack:int=0;
var canInitAttack:bool=false
var shockWake:ColorRect
func _ready() -> void:
	player=get_tree().get_first_node_in_group("player")
	shockWake= get_tree().get_first_node_in_group("shockWave")
	_ready_help()
	changeAttack()
	

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
	
	var shaderMat:ShaderMaterial= shockWake.material
	shaderMat.set_shader_parameter("center",origin)
	var tween = create_tween()
	tween.tween_method(set_shader_value, 0.0, 5.0, 3);


func set_shader_value(value: float):
	var shaderMat:ShaderMaterial= shockWake.material
	shaderMat.set_shader_parameter("radius",value)
	
	
func generateNumAttacks(min:int,max:int):
	randomize()
	numAttacks= randi_range(min,max)
	currentNumAttack=0

func activateAttack():
	canInitAttack=true

func stopSound():
	if get_tree().get_node_count_in_group("proyectile")==0:
		cancerbero.stopSound("audioElement")
