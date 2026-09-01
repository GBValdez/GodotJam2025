extends CanvasLayer

const DESIGN_SIZE := Vector2(576, 324)
const JOYSTICK_BASE := Vector2(68, 253)
const ATTACK_BASE := Vector2(499, 244)
const DASH_BASE := Vector2(563, 165)

func _ready() -> void:
	if OS.get_name() != "Android":
		queue_free()
		return
	get_viewport().size_changed.connect(_apply_layout)
	_apply_layout()

func _apply_layout() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	$joystick.position = Vector2(
		JOYSTICK_BASE.x,
		viewport_size.y - (DESIGN_SIZE.y - JOYSTICK_BASE.y)
	)
	$attack_button.position = Vector2(
		viewport_size.x - (DESIGN_SIZE.x - ATTACK_BASE.x),
		viewport_size.y - (DESIGN_SIZE.y - ATTACK_BASE.y)
	)
	$dash_button.position = Vector2(
		viewport_size.x - (DESIGN_SIZE.x - DASH_BASE.x),
		viewport_size.y - (DESIGN_SIZE.y - DASH_BASE.y)
	)
