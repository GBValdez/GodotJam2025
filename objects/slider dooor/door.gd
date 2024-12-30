extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open():
	$AnimationPlayer.play("open")
	General.applyPitchScale($AudioStreamPlayer2D,1,1.1)
func close():
	$AnimationPlayer.play("close")
	General.applyPitchScale($AudioStreamPlayer2D,0.9,1)
	
