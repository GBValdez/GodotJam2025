extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_press_signal(body: Node2D) -> void:
	get_parent().open()


func _on_button_delease_signal(body: Node2D) -> void:
	get_parent().close()
