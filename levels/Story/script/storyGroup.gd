extends Node
class_name storyGroup
var scenes:Array=[]
var index:int=0
var sceneCurrent:storyCommons=null
func _ready() -> void:
	get_viewport().size_changed.connect(_apply_layout)
	_apply_layout()
	modifyBlack(0,2)
	General.createTimer(0.5,nextScene)
	
func modifyBlack(a:float,time:float):
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property($CanvasLayer/ColorRect,"color",Color(0,0,0,a),time)

func nextScene():
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
