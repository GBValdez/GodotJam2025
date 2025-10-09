extends Area2D
var run:bool=false
@export var speed=60
func _process(delta: float) -> void:
	if run:
		global_position.y-=speed*delta

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):	
	if body.is_in_group("playerPro"):
		run=true
		General.createTimer(5,queue_free)
		$GPUParticles2D.emitting=true
