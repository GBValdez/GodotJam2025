extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func pressDoor(body: Node2D) -> void:
	$door.open()
	pass # Replace with function body.


func deleaseDoor(body: Node2D) -> void:
	$door.close()
	pass # Replace with function body.


func pressSlider(body: Node2D) -> void:
	$sliderDoor.open()
	pass # Replace with function body.


func deleaseSlider(body: Node2D) -> void:
	$sliderDoor.close()
	
	pass # Replace with function body.
