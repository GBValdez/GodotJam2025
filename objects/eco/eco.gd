extends Node2D

var previous:Array[ecoClass]
var counter: float=0
func _ready() -> void:
	previous= EcoSystem.previousInput.duplicate(true)
	EcoSystem.inputs.clear()
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	counter+=delta
	if not previous.is_empty():
		var current:ecoClass= previous.front()
		if current.time== counter:
			$player.direction=current.direction
			previous.pop_front()
			
	
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction=direction.normalized()
	EcoSystem._addAction(direction,counter)	
	
