extends Area2D
class_name  ButtonGame
signal  pressSignal (body:Node2D)
signal  deleaseSignal (body:Node2D)
var players:Array[Player]=[]
	


func _on_area_entered(area: Area2D) -> void:
	if not area.get_parent().is_in_group("player"):
		return
	var play:Player=area.get_parent()
	players.append(play)
	pressSignal.emit(area.get_parent())
	$AnimationPlayer.play("on")
	General.applyPitchScale($audioBtn,1,1.2)
	pass # Replace with function body.


func _on_area_exited(area: Area2D) -> void:
	if not area.get_parent().is_in_group("player"):
		return
	var play: Player = area.get_parent()
	if play in players:
		players.erase(play)  # Remueve el jugador del array
		deleaseSignal.emit(area.get_parent())
	if players.is_empty():
		$AnimationPlayer.play("off")
