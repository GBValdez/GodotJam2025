extends enemyBasic
class_name CancerBerusCommons
var player:Player
var bulletScene
var dirShot:Vector2= Vector2.ZERO
@onready var shotPointer= $sprite/shotPointer
func _ready():
	liveBar= $"CanvasLayer/live-bar"
	conectHit()
	_ready_help()
	liveBar.start(health)
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
	


func _physics_process(delta: float) -> void:
	move(delta)
	animation()

func animation():
	if velocity.length() > 0:
		anim.play("run")
		
	else:
		anim.play("idle")
	if velocity.x!=0:
		sprite.scale.x= sign(velocity.x) * abs(sprite.scale.x)
