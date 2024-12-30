extends Area2D
class_name  electricity
var on:bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setOn()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setOn():
	$AnimationPlayer.play("play")

func setOff():
	$AnimationPlayer.play("offing")	


func playAnimationOn():
	$AnimationPlayer.play("on")
	on=true
	monitoring=true

func offing():
	on=false
	monitoring=false

func validate(body:Node2D)->bool:
	if not body.is_in_group("player"):
		return false
	var player:Player= body
	if not player.enableControl:
		return false
	return true

	


func _on_body_entered(body: Node2D) -> void:
	if (validate(body)):
			$aud_bucle.play()
			EcoSystem._reboot()
