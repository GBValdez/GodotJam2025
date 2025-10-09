extends CanvasLayer

func _ready() -> void:
	if OS.get_name()!="Android":
		queue_free()
