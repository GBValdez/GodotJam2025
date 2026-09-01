extends CanvasLayer

const DESIGN_SIZE := Vector2(576, 324)
const SAFE_MARGIN := 18.0
const ACTION_MARGIN_X := 54.0
const ACTION_MARGIN_Y := 46.0
const ACTION_GAP := 22.0
const BUTTON_BASE_SCALE := 0.089
const BUTTON_MIN_SCALE := 0.082
const BUTTON_MAX_SCALE := 0.115
const JOYSTICK_MIN_SCALE := 0.88
const JOYSTICK_MAX_SCALE := 1.18
const CONTROL_ALPHA := 0.52

func _ready() -> void:
	if OS.get_name() != "Android":
		queue_free()
		return
	_configure_controls()
	get_viewport().size_changed.connect(_apply_layout)
	_apply_layout()

func _configure_controls() -> void:
	$joystick.modulate.a = CONTROL_ALPHA
	$joystick/Joystick.modulate.a = CONTROL_ALPHA
	$joystick/JoystickOutline.modulate.a = CONTROL_ALPHA
	$attack_button.modulate.a = CONTROL_ALPHA
	$dash_button.modulate.a = CONTROL_ALPHA

func _apply_layout() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var control_scale := _get_control_scale(viewport_size)
	$joystick.scale = Vector2.ONE * control_scale
	$attack_button.scale = Vector2.ONE * (BUTTON_BASE_SCALE * control_scale)
	$dash_button.scale = Vector2.ONE * (BUTTON_BASE_SCALE * control_scale)

	var joystick_radius := _get_joystick_radius() * control_scale
	$joystick.position = Vector2(
		SAFE_MARGIN + joystick_radius,
		viewport_size.y - SAFE_MARGIN - joystick_radius
	)

	var attack_size := _get_touch_size($attack_button)
	var dash_size := _get_touch_size($dash_button)
	$attack_button.position = Vector2(
		viewport_size.x - ACTION_MARGIN_X - attack_size.x * 0.5,
		viewport_size.y - ACTION_MARGIN_Y - attack_size.y * 0.5
	)
	$dash_button.position = Vector2(
		viewport_size.x - ACTION_MARGIN_X - dash_size.x * 0.5,
		$attack_button.position.y - attack_size.y * 0.5 - ACTION_GAP - dash_size.y * 0.5
	)

func _get_control_scale(viewport_size: Vector2) -> float:
	var scale_factor: float = viewport_size.x / DESIGN_SIZE.x
	var height_scale: float = viewport_size.y / DESIGN_SIZE.y
	if height_scale < scale_factor:
		scale_factor = height_scale
	var min_scale: float = BUTTON_MIN_SCALE / BUTTON_BASE_SCALE
	if JOYSTICK_MIN_SCALE > min_scale:
		min_scale = JOYSTICK_MIN_SCALE
	var max_scale: float = BUTTON_MAX_SCALE / BUTTON_BASE_SCALE
	if JOYSTICK_MAX_SCALE < max_scale:
		max_scale = JOYSTICK_MAX_SCALE
	if scale_factor < min_scale:
		scale_factor = min_scale
	if scale_factor > max_scale:
		scale_factor = max_scale
	return scale_factor

func _get_touch_size(button: TouchScreenButton) -> Vector2:
	if button.texture_normal == null:
		return Vector2(96, 96) * button.scale
	return button.texture_normal.get_size() * button.scale

func _get_joystick_radius() -> float:
	var collision := $joystick/CollisionShape2D as CollisionShape2D
	if collision != null and collision.shape is CircleShape2D:
		var circle := collision.shape as CircleShape2D
		return circle.radius
	return 64.0
