extends Entity
class_name enemyBasic;
@export_category("Enemy Atributes")
@export var forceHit=1000;
@export var forceHitMe=1000;

@onready var hitAreaMe:Area2D= $hitMe
@onready var hitAreaOther:Area2D= $hitOther

var playerHitMe:Area2D

	
func onHitMe(body: Node2D):
	if (body.is_in_group("player-damage")):
		hitDamage(1,body.global_position,forceHitMe,false)

	
func onHitOther(body: Node2D):
	if (body.is_in_group("player")):
		var entityBody = body as Entity
		if playerHitMe== null:
			entityBody.hitDamage(1,global_position,forceHit)

func exitHetme(body:Node2D):
	if (body.is_in_group("player-damage")):
		playerHitMe=null


func conectHit():
	if(hitAreaMe!=null):
		hitAreaMe.area_entered.connect(onHitMe)
		hitAreaMe.area_exited.connect(exitHetme)
	if(hitAreaOther!=null):
		hitAreaOther.body_entered.connect(onHitOther)

func is_in_damage()-> bool:
	return not anim.current_animation  in ["hit"]
