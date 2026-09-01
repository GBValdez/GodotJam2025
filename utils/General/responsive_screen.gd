extends Node
class_name ResponsiveScreen

@export var target_path: NodePath
@export var design_size := Vector2(576, 324)
@export var use_camera_zoom := false
@export var camera_path: NodePath
@export var fullscreen_overlay_groups: Array[StringName] = [&"blackSquare", &"glitchLayout"]

var _base_position := Vector2.ZERO
var _target: Node2D
var _camera: Camera2D

func _ready() -> void:
	_target = get_node_or_null(target_path) as Node2D
	_camera = get_node_or_null(camera_path) as Camera2D
	if _target != null:
		_base_position = _target.position
	get_viewport().size_changed.connect(_apply_layout)
	_apply_layout()

func _apply_layout() -> void:
	var visible_size := get_viewport().get_visible_rect().size
	if _target != null:
		var offset := (visible_size - design_size) * 0.5
		if use_camera_zoom and _camera != null:
			offset /= _camera.zoom
		_target.position = _base_position + offset
	_apply_fullscreen_overlays()

func _apply_fullscreen_overlays() -> void:
	for group_name in fullscreen_overlay_groups:
		for node in get_tree().get_nodes_in_group(group_name):
			var control := node as Control
			if control == null:
				continue
			control.set_anchors_preset(Control.PRESET_FULL_RECT)
			control.offset_left = 0
			control.offset_top = 0
			control.offset_right = 0
			control.offset_bottom = 0
