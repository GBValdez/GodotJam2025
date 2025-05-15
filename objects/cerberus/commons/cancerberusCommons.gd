extends enemyBasic
class_name CancerBerusCommons
var player:Player
var bulletScene
var dirShot:Vector2= Vector2.ZERO
@onready var shotPointer= $sprite/shotPointer
@onready var visibleNotifier:VisibleOnScreenNotifier2D=$VisibleOnScreenNotifier2D
@onready var timerRastro:Timer= $timerRastro
func _ready():
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
		if timerRastro.is_stopped():
			timerRastro.start()
			var newColor:Color = Color.WHITE
			newColor.a=0.2
			General.spriteShadow(sprite,0.1,newColor)
			print("miyamoto")
	else:
		anim.play("idle")
	if velocity.x!=0:
		sprite.scale.x= sign(velocity.x) * abs(sprite.scale.x)
	
