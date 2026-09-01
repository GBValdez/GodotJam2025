extends Node2D

const DESIGN_SIZE := Vector2(576, 324)
const MARKER_BASE_Y := 8.0

func _ready() -> void:
	get_viewport().size_changed.connect(_apply_layout)
	_apply_layout()
	$CanvasLayer/ColorRect.visible = true
	modifyBlack(0, 1)
	General.createTimer(5, _showTwo)

func _apply_layout() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var marker := $CanvasLayer/Marker2D
	marker.position = Vector2(viewport_size.x * 0.5, MARKER_BASE_Y + max(0.0, (viewport_size.y - DESIGN_SIZE.y) * 0.5))
	for rect_path in ["CanvasLayer/ColorRect", "CanvasLayer/ColorRect2"]:
		var rect := get_node_or_null(rect_path) as ColorRect
		if rect != null:
			rect.set_anchors_preset(Control.PRESET_FULL_RECT)
			rect.offset_left = 0
			rect.offset_top = 0
			rect.offset_right = 0
			rect.offset_bottom = 0

func _showTwo():
	modifyBlack(1, 0.5)
	General.createTimer(1, _showTwoNow)

func _showTwoNow():
	get_tree().change_scene_to_file("res://levels/MenuPrincipal/menu_principal.tscn")

func modifyBlack(a: float, time: float):
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property($CanvasLayer/ColorRect, "color", Color(0, 0, 0, a), time)
