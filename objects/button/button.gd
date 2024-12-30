extends Area2D
class_name  ButtonGame
signal  pressSignal (body:Node2D)
signal  deleaseSignal (body:Node2D)
var players:Array[Player]=[]
func _ready() -> void:
	pass # Replace with function body.

func press(body:Node2D):
	if not body.is_in_group("player"):
		return
	var play:Player=body
	players.append(play)
	pressSignal.emit(body)

func delease(body: Node2D):
	if not body.is_in_group("player"):
		return
	var play: Player = body
	if play in players:
		players.erase(play)  # Remueve el jugador del array
		deleaseSignal.emit(body)
		
	
