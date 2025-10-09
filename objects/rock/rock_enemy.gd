extends enemyBasic
var followPlayer:bool=false
func _ready() -> void:
	conectHit()
	
func _physics_process(delta: float) -> void:
	if followPlayer:
		var player = General.players[0]
		direction= (player.global_position-global_position).normalized()
		move(delta)


func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		followPlayer=true
		$detectPlayer.queue_free()

func onHitDamage(forceHit:bool,damage:float):
	super.onHitDamage(forceHit,damage)
	if health<=0:
		General.createTimer(2,queue_free)
