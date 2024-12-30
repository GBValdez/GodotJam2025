extends Node2D

var previous:Array[ecoClass]
var counter: float=0
var index:int=0
@export var first:bool=false

func _ready() -> void:
	General.createTimer(0.1,start)	
	previous= EcoSystem.previousInput
	EcoSystem.inputs.clear()
	if previous.is_empty():
		set_physics_process(false)
		$player.queue_free()
	pass # Replace with function body.


	

func start() -> void:
	if not first:
		if (General.currentEndpont==null):
			queue_free()
			return
		if get_parent().myKey!= General.currentEndpont.myKey :
			queue_free()
	else:
		if (General.currentEndpont!=null):
			queue_free()
			return



func _physics_process(delta: float) -> void:
	counter+=delta
	if not previous.is_empty() and index<previous.size():
		var current:ecoClass= previous[index]
		if current.time== counter:
			$player.direction=current.direction
			index+=1
	else:
		$player.direction= Vector2.ZERO		
	

	
