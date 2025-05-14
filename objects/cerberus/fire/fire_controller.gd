extends ControllersCommons
var attackAssault:bool=false
func _ready_help():
	bulletScene=load("res://objects/cerberus/fire/balls_fire/ball_fire.tscn")
	typeAttack=["assault","side","cross"]
	var timer = General.createTimer(1,borrame)
	
func borrame():
	attack="assault"
func assault(delta:float):
	if not attack=="assault":
		return
	print("amigo")
	var dirPlayer:Vector2=player.global_position-cancerbero.global_position 
	if initAttack:
		cancerbero.SPEED=1000
		cancerbero.INERTIA=800
		cancerbero.SPEED_LIMIT=1300
		
		cancerbero.LIMIT=500
		cancerbero.direction= dirPlayer.normalized() 
		initAttack=false
		currentNumAttack+=1
	else:
		if dirPlayer.length()<500:
			shotWithTimeCerbero()
		else:
			cancerbero.direction=Vector2.ZERO	
			if cancerbero.velocity.length()<10:
				cancerbero.direction= dirPlayer.normalized() 
				currentNumAttack+=1
				 

func _physics_process(delta: float) -> void:
	assault(delta)	
