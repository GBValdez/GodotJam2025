extends  Node
var inputs:Array[ecoClass]=[]
var previousInput:Array[ecoClass]=[]

func _addAction(direction:Vector2,counter:float)->void:	
	if not inputs.is_empty():
		var previousAction:ecoClass= inputs.back()
		if previousAction.direction == direction:
			return		
	var action:ecoClass= ecoClass.new()
	action.direction=direction
	action.time=counter
	inputs.append(action)

func _reboot():
	previousInput=inputs.duplicate()
	get_tree().reload_current_scene()
