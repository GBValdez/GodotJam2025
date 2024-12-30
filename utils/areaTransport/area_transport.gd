extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	body.global_position=global_position
	general.showEffectGlitch(true)
	$Timer.start()
	randomize()
	$audioError.pitch_scale= randf_range(1,1.2)
	$audioError.play()


func _on_timer_timeout() -> void:
	general.showEffectGlitch(false)
