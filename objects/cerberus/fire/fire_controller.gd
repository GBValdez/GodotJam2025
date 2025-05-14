extends ControllersCommons
var attackAssault:bool=false

func _ready_help():
	bulletScene=load("res://objects/cerberus/fire/balls_fire/ball_fire.tscn")
	typeAttack=["assault","side","cross"]

func assault(delta:float):
	if attack!="assault":
		return
	var dirPlayer:Vector2=cancerbero.global_position - player.global_position
	if initAttack:
		cancerbero.SPEED=300
		cancerbero.LIMIT=500
		cancerbero.direction= dirPlayer.normalized() 
		initAttack=false
	else:
		if dirPlayer.length()<300:
			shotWithTimeCerbero()
		else:
			cancerbero.direction=Vector2.ZERO	
		

func _physics_process(delta: float) -> void:
	assault(delta)	
