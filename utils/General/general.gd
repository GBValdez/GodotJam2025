extends Node
var players:Array[Player]=[]
var currentLevel:level
var currentEndpont:endpointDto
var savePath:String="user://Data.dat"
var dataGame={
	"music_db":1,
	"sfx_db":1,
	"currentLevel":"res://Levels/tutorial.tscn",
	"endpoint":"",
	"deaths":0,
	"hit":0
}
var endGame:bool=false
var fase:int=0
func string_to_vector2(input: String) -> Vector2:
	var partsTemp = input.replace("(","").replace(")","").split(",")
	if partsTemp.size() == 2:
		return Vector2(partsTemp[0].to_float(), partsTemp[1].to_float())
	else:
		print("Error: el formato no es correcto")
		return Vector2.ZERO





func shakeCamera(force: float, time: float):
	get_tree().get_nodes_in_group("cameraGamePri")[0].makeShake(
		force, time
	)
func makeShakeCurrent(force: float):
	get_tree().get_nodes_in_group("cameraGamePri")[0].makeShakeCurrent(
		force
	)
	
func shakeCameraDir(force: float, time: float,dir:Vector2):
	get_tree().get_nodes_in_group("cameraGamePri")[0].makeShakeDir(
		force, time,dir
	)
	

func showEffectGlitch(show: bool):
	get_tree().get_nodes_in_group("cameraGamePri")[0].showEffectGlitch(
		show
	)

func spriteShadow(sprite:Sprite2D,time:float,colorInit:Color):
	var level= get_tree().get_first_node_in_group("level")
	var duplicateSprite =sprite.duplicate() as Sprite2D
	level.add_child(duplicateSprite)
	duplicateSprite.global_position=sprite.global_position
	duplicateSprite.modulate=colorInit
	duplicateSprite.z_index=-1
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN)
	colorInit.a=0
	TWEN.tween_property(duplicateSprite, "modulate", colorInit, time)
	TWEN.connect("finished", endEffectShadow.bind(duplicateSprite))

func endEffectShadow(sprite:Sprite2D):
	sprite.queue_free()
	
func get_active_camera()-> camera2dInfo:
	return get_tree().get_nodes_in_group("cameraGamePri")[0].get_active_camera()

func setCamera(newCamera:PhantomCamera2D):
	for camera in currentLevel.listPhamToCamera :
			if camera.camera!= newCamera:
				camera.camera.priority=0
				for zone in camera.zones:
					zone.visible=false
					zone.process_mode=Node.PROCESS_MODE_DISABLED	
			else:
				camera.camera.priority=30
				for zone in camera.zones:
					zone.visible=true
					zone.process_mode=Node.PROCESS_MODE_INHERIT
	

func saveData():
	return
	var save_file=FileAccess.open(savePath,FileAccess.WRITE)
	save_file.store_var(dataGame)
	save_file.close()
	save_file=null
	
func loadSaveData():
	return
	if FileAccess.file_exists(savePath):
		var save_file=FileAccess.open(savePath,FileAccess.READ)
		dataGame=save_file.get_var()
		save_file.close()
		save_file=null


func get_grouped_descendants(root_node: Node, group_name: String) -> Array:
	var descendants_in_group:Array = []
	for descendant:Node2D in root_node.get_children():
		if descendant.is_in_group(group_name):
			descendants_in_group.append(descendant)
		var nodes:Array=get_grouped_descendants(descendant,group_name)
		descendants_in_group.append_array(nodes)
	return descendants_in_group

	
func getNodeByGroup(node:Node2D,groupName:String) -> Array[Node2D]:
	var nodesInGroup:Array[Node2D]= get_tree().get_nodes_in_group(groupName) as Array[Node2D]
	var result:Array[Node2D]=[]
	for nodeCurrent in nodesInGroup:
		if nodeCurrent.is_inside_tree() and (nodeCurrent.get_parent()==node):
			result.append(nodeCurrent)
	return result		


func go_to_level(levelNew:String):
	for player in players:
		if player != null:
			player.reset()
	createTimer(2,endLevel.bind(levelNew))
	
func  endLevel(levelNew:String):
	var squareBlock= get_tree().get_first_node_in_group("blackSquare")	
	squareBlock.visible=true
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property(squareBlock,"color",Color(0,0,0,1),1)
	TWEN.connect("finished",redirection.bind(levelNew))
	
	var musicNode:AudioStreamPlayer=get_tree().get_first_node_in_group("music_node")	
	if(musicNode!=null):
		var TWENMUSIC = get_tree().create_tween()
		TWENMUSIC.set_trans(Tween.TRANS_CUBIC)
		TWENMUSIC.set_ease(Tween.EASE_IN_OUT)
		TWENMUSIC.tween_property(musicNode,"volume_db",-100,1)

		
func redirection(redirectLevel:String):
	if(redirectLevel!=""):
		if redirectLevel=="reset":
			get_tree().reload_current_scene()
		else:
			currentEndpont=null
			get_tree().change_scene_to_file(redirectLevel)
	else:
		get_tree().quit()



func createTimer(time:float, fnc:Callable):
	var timer= get_tree().create_timer(time)
	timer.connect("timeout",fnc)

	
		
	
	
func transMusic(music1:AudioStreamPlayer,music2:AudioStreamPlayer,duration:float,fnc:Callable):
	var tween1= create_tween()
	tween1.set_trans(Tween.TRANS_CUBIC)
	tween1.set_ease(Tween.EASE_IN_OUT)
	tween1.tween_property(music1,"volume_db",-100,duration)
	
	var soundDb= music2.volume_db
	music2.volume_db=0
	
	var tween2= create_tween()
	tween2.set_trans(Tween.TRANS_CUBIC)
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(music2,"volume_db",soundDb,duration)
	
	if fnc!=null:		
		tween2.connect("finished",fnc)

func applyPitchScale(audio,min:float,max:float):
	if(audio.playing):
		return
	randomize()
	var pich= randf_range(min,max)
	audio.pitch_scale=pich
	audio.play()

func shakeSprite(sprite:Sprite2D,min:float=0.1,max:float=0.1,offset:bool=false):
	randomize()
	var randomPos:Vector2=Vector2(randf_range(min,max),randf_range(min,max))
	if offset:
		sprite.offset= randomPos
	else:
		sprite.position= randomPos
	return randomPos

func addNode(package,pos:Vector2):
	var nodeCurrent= package.instantiate()
	var level= get_tree().get_first_node_in_group("level")
	level.add_child(nodeCurrent)
	nodeCurrent.global_position=pos
	return nodeCurrent
