extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func validate(body:Area2D)->bool:
	if not body.get_parent().is_in_group("player"):
		return false
	var player:Player= body.get_parent()
	if not player.enableControl:
		return false
	return true


func _on_area_entered(area: Area2D) -> void:
	if (validate(area)):
		$aud_bucle.play()
		EcoSystem._reboot()
