extends Node
class_name storyGroup
const SKIP_WHOLE_HOLD_TIME := 1.8
var scenes:Array=[]
var index:int=0
var sceneCurrent:storyCommons=null
var skip_hold_time := 0.0
var skip_all_started := false
func _ready() -> void:
	get_viewport().size_changed.connect(_apply_layout)
	_apply_layout()
	modifyBlack(0,2)
	General.createTimer(0.5,nextScene)

func _process(delta: float) -> void:
	if skip_all_started:
		return
	if Input.is_action_pressed("ui_action"):
		skip_hold_time += delta
		if skip_hold_time >= SKIP_WHOLE_HOLD_TIME:
			skip_all_scenes()
	else:
		skip_hold_time = 0.0

func skip_all_scenes() -> void:
	skip_all_started = true
	skip_hold_time = 0.0
	index = scenes.size()
	if sceneCurrent != null:
		sceneCurrent.queue_free()
		sceneCurrent = null
	modifyBlack(1, 0.35)
	await get_tree().create_timer(0.35).timeout
	endScenes()
	
func modifyBlack(a:float,time:float):
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property($CanvasLayer/ColorRect,"color",Color(0,0,0,a),time)

func nextScene():
	if skip_all_started:
		return
	if index==scenes.size():
		modifyBlack(1,2)
		General.createTimer(2,endScenes)
		return
	if sceneCurrent!=null: 
		sceneCurrent.queue_free()
	sceneCurrent= General.addNode(scenes[index],Vector2.ZERO)
	sceneCurrent.connect("finishScene",nextScene)
	index+=1

func endScenes():
	pass

func _apply_layout() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var fade_rect := get_node_or_null("CanvasLayer/ColorRect") as ColorRect
	if fade_rect != null:
		fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		fade_rect.offset_left = 0
		fade_rect.offset_top = 0
		fade_rect.offset_right = 0
		fade_rect.offset_bottom = 0
	var skip_button := get_node_or_null("CanvasLayer/attack_button") as TouchScreenButton
	if skip_button != null and skip_button.texture_normal != null:
		var texture_size := skip_button.texture_normal.get_size()
		skip_button.position = Vector2.ZERO
		skip_button.scale = Vector2(
			viewport_size.x / max(texture_size.x, 1.0),
			viewport_size.y / max(texture_size.y, 1.0)
		)
