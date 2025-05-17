extends Hit
@export() var shotDirectionPlayer:bool=false
func _ready() -> void:
	super._ready()
	shotPlayer()
func shotPlayer():
	if shotDirectionPlayer:
		var player:Player= get_tree().get_first_node_in_group("player")
		var dx = player.position.x - position.x
		var dy = player.position.y - position.y
		var angle = atan2(dy, dx)
		global_rotation = angle
		
func _process(delta: float) -> void:
	General.shakeSprite($sprite,2)


func _on_timer_start_timeout() -> void:
	$AnimationPlayer.play("shot")
	$audioRay.play()


func _on_timer_end_timeout() -> void:
	$AnimationPlayer.play("disappear")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="disappear":
		queue_free()
