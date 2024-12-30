extends  Node
var inputs:Array[ecoClass]=[]
var previousInput:Array[ecoClass]=[]
var counter:float=0

func _addAction(direction:Vector2,counter:float)->void:	
	if counter>30:
		return
	if not inputs.is_empty():
		var previousAction:ecoClass= inputs.back()
		if previousAction.direction == direction:
			return		
	var action:ecoClass= ecoClass.new()
	action.direction=direction
	action.time=counter
	inputs.append(action)

func _reboot():
	General.endGame=true
	previousInput=inputs.duplicate()
	General.go_to_level("reset")
	
func _physics_process(delta: float) -> void:
	if General.endGame:
		return
	
	counter+=delta
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction=direction.normalized()
	_addAction(direction,counter)	
		
