extends Node
var joysticks:Array[Joystick]=[]
func _ready() -> void:
	initJoysTick()
func initJoysTick():
	joysticks.clear()
	var nodes= get_tree().get_nodes_in_group("Joystick")
	for nod in nodes:
		joysticks.append(nod)
