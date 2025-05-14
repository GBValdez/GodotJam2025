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

func _ready() -> void:
	player=General.players[0]
	changeAttack()
	_ready_help()

func _ready_help():
	pass

func shot(pos:Vector2,direction:Vector2=Vector2.ZERO):
	var bulletCurrent:Proyectile=bulletScene.instantiate()
	bulletCurrent.global_position=pos
	bulletCurrent.direction=direction
	var level= get_tree().get_first_node_in_group("level")
	level.add_child(bulletCurrent)

func shotWithTime(pos:Vector2,direction:Vector2=Vector2.ZERO):
	if not shotTimer.is_stopped():
		return
	shot(pos,direction)
	shotTimer.start()

func shotWithTimeCerbero(direction:Vector2=Vector2.ZERO):
	if not shotTimerCancerbero.is_stopped():
		return
	cancerbero.dirShot=direction
	cancerbero.shot()
	shotTimerCancerbero.start()

func changeAttack():
	attack= typeAttack.pick_random()
	initAttack=true
