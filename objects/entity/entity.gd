extends CharacterBody2D
class_name  Entity
@export_category("General")
@export var health: int = 1;
@export var elasticy:float=0.2

@export_category("Motion")
@export var SPEED = 300.0
@export var INERTIA = 100.0
@export var LIMIT=100
@export var SPEED_LIMIT= 300.0;

var inmortal:bool=false
@onready var anim: AnimationPlayer = $AnimationPlayer
var direction:Vector2= Vector2.ZERO
@onready var sprite = $sprite

func apply_limit(delta)->void:
	var normalizeV= velocity.normalized()
	var limitNormalize= normalizeV * LIMIT
	if abs(velocity.x) > abs(limitNormalize.x) :
		velocity.x -= normalizeV.x * SPEED_LIMIT * delta  
	if abs(velocity.y) > abs(limitNormalize.y):
		velocity.y -= normalizeV.y * SPEED_LIMIT * delta

func hitDamage(damage: int, point: Vector2,force:float,forceHit:bool=false):
	if ((health > 0 && not inmortal) or forceHit):	
		health -= damage
		velocity = (global_position - point).normalized() * force
		anim.play("hit")
	onHitDamage(forceHit)
	if (health <= 0):
		death()

func onHitDamage(forceHit:bool):
	pass
func death():
	pass

#func animScale():
#	var velocityPorc: Vector2 = Vector2.ZERO
#	velocityPorc.x = (100 * velocity.x / LIMIT_V.x) / 100
#	velocityPorc.y = (100 * velocity.y / LIMIT_V.y) / 100
#	sprite.scale.y=1-abs(velocityPorc.x)*elasticy
#	sprite.scale.x=sign(sprite.scale.x)-abs(velocityPorc.y)*elasticy*sign(sprite.scale.x)
#	#sprite.scale.x=1-velocityPorc.x*0.5
	#print(motionScale)
	
#func animScale():
	# Calcula un factor de velocidad basado en la longitud de la velocidad y la velocidad máxima
#	var speed_factor = sign(velocity.length() / LIMIT)
	
	# Aplica elasticidad a la escala del sprite
#	sprite.scale.x = sign(sprite.scale.x) * (1 - abs(speed_factor) * elasticy)  # Elasticidad horizontal
#	sprite.scale.y = sign(sprite.scale.y) * (1 - abs(speed_factor) * elasticy)  # Elasticidad vertical
