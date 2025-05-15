extends Proyectile
var player:Player
func _ready_help():
	player= get_tree().get_first_node_in_group("player")
func _physics_process(delta: float) -> void:
	
	motion(delta)
	if velocity.x==0:
		direction.x*=-1
	if velocity.y==0:
		direction.y*=-1
