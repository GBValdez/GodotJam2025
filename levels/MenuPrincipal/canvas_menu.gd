extends CanvasLayer
var desactive:bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Marker2D/VBoxContainer.finish=true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(not General.currentLevel.squareBlock.visible and not desactive):
		$Marker2D/VBoxContainer.finish=false
		desactive=true
	pass
