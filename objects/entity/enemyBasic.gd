extends Entity
class_name enemyBasic;

@export_category("Enemy Atributes")
@export var forceHit=1000;
@export var forceHitMe=1000;
@export var pichVolume:Vector2 = Vector2(1,1)
@onready var hitAreaMe:Area2D= $hitMe
@onready var hitAreaOther:Area2D= $hitOther
@onready var liveBar:LiveBar=$"live-bar"

var playerHitMe:Area2D

func onHitOther(body: Node2D):
	if (body.is_in_group("player")):
		var entityBody = body as Entity
		if playerHitMe== null:
			entityBody.hitDamage(1,global_position,forceHit)

func onHitOtherAvalaible(body: Node2D):
	if (body.is_in_group("player-avalaible")):
		var entityBody = body.get_parent().get_parent() as Player
		if entityBody!=null:
			entityBody.moreAttack(1)

func conectHit():
	if liveBar!=null:
		liveBar.start(health)
	if(hitAreaOther!=null):
		hitAreaOther.body_entered.connect(onHitOther)
		hitAreaOther.area_entered.connect(onHitOtherAvalaible)
	
func is_in_damage()-> bool:
	return not anim.current_animation  in ["hit"]

func move(delta:float):
	velocity += direction * SPEED*delta	
	apply_inertia(delta,direction)
	apply_limit(delta) 
	move_and_slide()

func destroy():
	anim.play("death")
	General.createTimer(1,queue_free)

func onHitDamage(forceHit:bool,damage:float):
	animEffects.play("hit")
	General.shakeCamera(2,0.2)
	inmortal=true
	liveBar.hit(damage)
	if health>0:
		playSound("audioHit",pichVolume.x,pichVolume.y)
		General.createTimer(2,normal)
	else:
		playSound("audioHit",0.7* pichVolume.x,0.8* pichVolume.y)
		$GPUParticles2D.emitting=true
		animEffects.play("dead")
		$hitMe/CollisionShape2D.disabled=true

func normal():
	animEffects.play("end_hit")
	inmortal=false
