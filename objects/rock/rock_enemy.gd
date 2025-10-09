extends enemyBasic
var followPlayer:bool=false
func _ready() -> void:
	conectHit()
	
func _physics_process(delta: float) -> void:
	if followPlayer:
		var player = General.players[0]
		if health>0:
			direction= (player.global_position-global_position).normalized()
		move(delta)
	animation()

func animation():
	print("hola")
	if health>0:
		General.shakeSprite(sprite,-5,5,true)
		if velocity.length()==0:
			anim.play("idle")
		else:
			anim.play("walk")
	else:
		General.shakeSprite($sprite,-20,20,true)
		anim.play("run")

func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		followPlayer=true
		$detectPlayer.queue_free()

func onHitDamage(forceHit:bool,damage:float):
	super.onHitDamage(forceHit,damage)
	if health<=0:
		$hitOther.queue_free()
		direction= Vector2.ZERO
		General.createTimer(2,queue_free)
