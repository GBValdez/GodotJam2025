extends Node
class_name storyGroup
var scenes:Array=[]
var index:int=0
var sceneCurrent:storyCommons=null
func _ready() -> void:
	nextScene()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_action") and sceneCurrent!=null:
		sceneCurrent._endScene()
		
func nextScene():
	if index==scenes.size():
		endScenes()
		return
	sceneCurrent= General.addNode(scenes[index],Vector2.ZERO)
	sceneCurrent.connect("finishScene",nextScene)
	index+=1

func endScenes():
	pass
