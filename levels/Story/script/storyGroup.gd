extends Node
class_name storyGroup
var scenes:Array=[]
var index:int=0
var sceneCurrent:storyCommons=null
func _ready() -> void:
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
