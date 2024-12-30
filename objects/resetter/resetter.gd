extends Area2D

var enter:bool=false
var player:Player
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_action") and enter:
		if not  player.enableControl:
			return
		EcoSystem._reboot()
		$aud_bucle.play()
		$AnimationPlayer.play("on")	
	pass

		


	

func validate(body:Area2D)->bool:
	if not body.get_parent().is_in_group("player"):
		return false
	var player:Player= body.get_parent()
	if not player.enableControl:
		return false
	return true


func _on_area_entered(area: Area2D) -> void:
	if not validate(area):
		return
	enter=true
	player=area.get_parent()
	pass # Replace with function body.


func _on_area_exited(area: Area2D) -> void:
	if not validate(area):
		return
	enter=false
