extends Node2D
class_name level
var listPhamToCamera: Array[camera2dInfo] = []
var listMusic:Array[AudioStreamPlayer]=[]
var squareBlock:ColorRect
@onready var animPlay:AnimationPlayer=$AnimationPlayer
@export var labelFPS:Label
@export var saveLevel:bool=true
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	General.currentLevel=self
	General.loadSaveData()
	print(General.currentEndpont)
	if(General.currentEndpont==null and General.dataGame.endpoint!=""):
		var dataEndpoint= General.dataGame.endpoint.split("|")
		var endpointData:endpointDto=endpointDto.new()
		endpointData.myKey= dataEndpoint[0]
		endpointData.key= dataEndpoint[1]
		endpointData.pos=General.string_to_vector2(dataEndpoint[2])
		General.currentEndpont=endpointData
func _ready():
	General.endGame=false
	setShadow(true)
	if(saveLevel):
		General.dataGame.currentLevel= scene_file_path
		General.saveData()
		
	var zones:Array[zone]
	for zone in get_tree().get_nodes_in_group("zoneCmr"):
		zones.append(zone)
	for camera in get_tree().get_nodes_in_group("cameraGame"):
		var currentCamera:camera2dInfo=camera2dInfo.new()
		currentCamera.camera=camera 
		currentCamera.zoom=camera.zoom
		currentCamera.zones=[]
		for zone in zones:
			if zone.camera == currentCamera.camera:
				currentCamera.zones.append(zone)
		listPhamToCamera.append(currentCamera)
	
	var playersNode=  get_tree().get_nodes_in_group("player")
	General.players.clear()
	for player in playersNode:
		General.players.append(player)
	if(General.currentEndpont!=null):
		var zoneCurrent:zone
		for zoneItem in zones:
			if zoneItem.key==General.currentEndpont.key:
				zoneCurrent=zoneItem
		if (zoneCurrent!=null):
			zoneCurrent.camera.tween_resource.duration=0
			General.setCamera(zoneCurrent.camera)
			var player= get_tree().get_first_node_in_group("playerPro")
			player.global_position=General.currentEndpont.pos
			var timer = get_tree().create_timer(0.1)
			timer.connect("timeout",normalCamera)
		else:
			General.currentEndpont=null
	squareBlock= get_tree().get_first_node_in_group("blackSquare")	
	squareBlock.visible=true
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property(squareBlock,"color",Color(0,0,0,0),1)
	TWEN.connect("finished",endInitSquare)
	
	var musicNode:Array[Node]=get_tree().get_nodes_in_group("music_node")	
	for musNode:AudioStreamPlayer in musicNode:
		listMusic.append(musNode)
		if(musNode.autoplay):
			var dbCurrent=musNode.volume_db
			musNode.volume_db=-100
			var TWENMUSIC = get_tree().create_tween()
			TWENMUSIC.set_trans(Tween.TRANS_CUBIC)
			TWENMUSIC.set_ease(Tween.EASE_IN_OUT)
			TWENMUSIC.tween_property(musNode,"volume_db",dbCurrent,1)
		
	
	pass # Replace with function body.
	
func setShadow(enable:bool):
	var nodes= get_tree().get_nodes_in_group("pointLight")
	for light  in nodes:
		var point :PointLight2D= light
		point.shadow_enabled=enable
	
func endInitSquare():
	squareBlock.visible=false
	var new:Array[Player]
	withouNullPlayer()
	for player in General.players:
		player.start()

func withouNullPlayer():
	var new :Array[Player]=[]
	for player in General.players:
		if player !=null:
			new.append(player)
	General.players= new

func normalCamera():
	General.get_active_camera().camera.tween_resource.duration=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
var indexCameraTest:int=0
func _physics_process(delta):

	#labelFPS.text=str(Engine.get_frames_per_second())+ " " + str(general.dataGame["score"])
	pass
