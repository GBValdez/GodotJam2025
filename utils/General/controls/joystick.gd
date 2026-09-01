extends Area2D
class_name Joystick

const DEADZONE := 0.18

var distancia: float = 0.0
var direccion: Vector2 = Vector2.ZERO
var index: int = -1

@onready var rango := $JoystickOutline
@onready var palanca := $Joystick
@onready var radio: float = $CollisionShape2D.shape.radius

func _input(event):
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		_reset()

func _handle_touch(event: InputEventScreenTouch) -> void:
	if event.pressed and index == -1:
		distancia = global_position.distance_to(event.position)
		if distancia <= radio * global_scale.x:
			index = event.index
			_update_stick(event.position)
	elif event.index == index:
		_reset()

func _handle_drag(event: InputEventScreenDrag) -> void:
	if event.index == index:
		_update_stick(event.position)

func _update_stick(touch_position: Vector2) -> void:
	var scaled_radio := radio * global_scale.x
	var offset := touch_position - global_position
	if offset.length() > scaled_radio:
		offset = offset.normalized() * scaled_radio
	palanca.global_position = global_position + offset
	direccion = offset / scaled_radio
	if direccion.length() < DEADZONE:
		direccion = Vector2.ZERO
	else:
		direccion = direccion.normalized() * ((direccion.length() - DEADZONE) / (1.0 - DEADZONE))

func _reset() -> void:
	index = -1
	distancia = 0.0
	palanca.position = Vector2.ZERO
	direccion = Vector2.ZERO
