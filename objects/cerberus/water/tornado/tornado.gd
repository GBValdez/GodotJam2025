extends Proyectile
var player:Player
var forceAtraction:float=1200
func _ready_help():
	player= get_tree().get_first_node_in_group("player")
func _physics_process(delta: float) -> void:
	
	motion(delta)
	if velocity.x==0:
		direction.x*=-1
	if velocity.y==0:
		direction.y*=-1
	_atraction(delta)
func _atraction(delta:float):
	var dirPlayer:Vector2=global_position-player.global_position
	player.velocity+= dirPlayer.normalized()*forceAtraction*delta
	print("papapapap")
