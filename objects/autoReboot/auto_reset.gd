extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("aaaa")
	if (validate(body)):
		$aud_bucle.play()
		EcoSystem._reboot()

	pass # Replace with function body.

func validate(body:Node2D)->bool:
	if not body.is_in_group("player"):
		return false
	var player:Player= body
	if not player.enableControl:
		return false
	return true
