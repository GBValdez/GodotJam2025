extends Area2D

var enter:bool=false
var player:Player
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_action") and enter:
		if not  player.enableControl:
			return
		player.reset()
		$aud_bucle.play()
		#EcoSystem._reboot()
	pass


func _on_body_entered(body: Node2D) -> void:
	if not validate(body):
		return
	enter=true
	player=body
		


func _on_body_exited(body: Node2D) -> void:
	if not validate(body):
		return
	enter=false

func validate(body:Node2D)->bool:
	if not body.is_in_group("player"):
		return false
	var player:Player= body
	if not player.enableControl:
		return false
	return true


func _on_aud_bucle_finished() -> void:
	pass # Replace with function body.
