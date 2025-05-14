extends Entity
class_name enemyBasic;
@onready var hitAreaMe:Area2D= $hitMe
@onready var hitAreaOther:Area2D= $hitOther
var playerHitMe:Entity

	
func onHitMe(body: Node2D):
	if (body.is_in_group("player")):
		var entityBody = body as Entity
		if(entityBody.global_position.y<global_position.y):
			playerHitMe= entityBody			
			body.velocity.y=-200
			hitDamage(1,body.global_position,200,false)

	
func onHitOther(body: Node2D):
	if (body.is_in_group("player")):
		var entityBody = body as Entity
		if playerHitMe== null:
			entityBody.hitDamage(1,global_position,200)

func exitHetme(body:Node2D):
	if (body.is_in_group("player")):
		playerHitMe=null


func conectHit():
	if(hitAreaMe!=null):
		hitAreaMe.body_entered.connect(onHitMe)
		hitAreaMe.body_exited.connect(exitHetme)
	if(hitAreaOther!=null):
		hitAreaOther.body_entered.connect(onHitOther)
	#hitAreaMe.connect("body_entered",onHitMe)
	#hitAreaOther.connect("body_entered",onHitOther)

func is_in_damage()-> bool:
	return not anim.current_animation  in ["hit"]
