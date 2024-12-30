extends StaticBody2D
var isOpen:bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open():
	if isOpen:
		return
	isOpen=true
	$AnimationPlayer.play("open")
	General.applyPitchScale($AudioStreamPlayer2D,1,1.1)
func close():
	if not isOpen:
		return
	isOpen=false
	$AnimationPlayer.play("close")
	General.applyPitchScale($AudioStreamPlayer2D,0.9,1)
	
