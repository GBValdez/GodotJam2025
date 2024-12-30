extends Node




func _on_button_press_signal(body: Node2D) -> void:
	get_parent().open()
	print("presion")
	pass # Replace with function body.


func _on_button_delease_signal(body: Node2D) -> void:
	get_parent().close()
	pass # Replace with function body.
