extends enemyBasic
class_name CancerBerusCommons
var player:Player
var bulletScene
var dirShot:Vector2= Vector2.ZERO
@onready var shotPointer= $sprite/shotPointer
func _ready():
	print("emepzar")
	conectHit()
	_ready_help()

func _ready_help():
	pass
	
	
func shot():
	var bulletCurrent:Proyectile=bulletScene.instantiate()
	bulletCurrent.global_position=shotPointer.global_position
	bulletCurrent.direction=dirShot
	var level= get_tree().get_first_node_in_group("level")
	level.add_child(bulletCurrent)
	playSound("audioElement",1,1.2)
	return bulletCurrent
	

func motion(delta:float):
	velocity += direction * SPEED*delta	
	apply_inertia(delta,direction)
	apply_limit(delta) 
	move_and_slide()

func _physics_process(delta: float) -> void:
	motion(delta)
	animation()

func animation():
	if velocity.length() > 0:
		anim.play("run")
		
	else:
		anim.play("idle")
	if velocity.x!=0:
		sprite.scale.x= sign(velocity.x) * abs(sprite.scale.x)
	
func onHitDamage(forceHit:bool):
	animEffects.play("hit")
	General.shakeCamera(2,0.2)
	inmortal=true
	if health>0:
		playSound("audioHit")
		General.createTimer(5,normal)
		print("auxilio")
	else:
		playSound("audioHit",0.7,0.8)
		$hitMe/CollisionShape2D.disabled=true

func normal():
	animEffects.play("end_hit")
	inmortal=false
	
