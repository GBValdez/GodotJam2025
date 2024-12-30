extends Camera2D

# Called when the node enters the scene tree for the first time.
var isShake: bool = false
var forceShake: float = 0
var dirShake:Vector2=Vector2.ZERO
var cameraOrigin:camera2dInfo
@onready var glitchLayout: ColorRect = $CanvasLayer/glitchLayout
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	var nodes=get_tree().get_nodes_in_group("cameraGame")
	
func _process(delta):
	if (isShake && dirShake==Vector2.ZERO):
		var x = randf_range( - forceShake, forceShake)
		var y = randf_range( - forceShake, forceShake)
		offset = Vector2(x, y)
	
			

func makeShake(force: float, time: float):
	forceShake = force
	isShake = true;
	startAlarm(time)
	
func makeShakeCurrent(force: float):
	if(not isShake):
		var x = randf_range( - force, force)
		var y = randf_range( - force, force)
		offset = Vector2(x, y)
	

func _on_Timer_timeout():
	isShake = false
	offset = Vector2.ZERO
	dirShake=Vector2.ZERO
	
func showEffectGlitch(showEffect: bool):
	glitchLayout.visible = showEffect
	
func makeShakeDir(force: float, time: float,dir:Vector2):
	forceShake = force
	isShake = true;
	dirShake=dir
	cameraOrigin=get_active_camera()
	offset=Vector2.ZERO
			
	var TWEN = create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN )
	TWEN.tween_method(interPoolShake,0,100,time)
	
	var TWEENRZOOM = create_tween()
	TWEENRZOOM.set_trans(Tween.TRANS_LINEAR)
	TWEENRZOOM.set_ease(Tween.EASE_OUT )
	TWEENRZOOM.tween_property(cameraOrigin.camera,"zoom",cameraOrigin.zoom,time*10).set_delay(time*10)
	
	var TWEENROFFSET = create_tween()
	TWEENROFFSET.set_trans(Tween.TRANS_LINEAR)
	TWEENROFFSET.set_ease(Tween.EASE_OUT )
	TWEENROFFSET.tween_property(self,"offset",Vector2.ZERO,time*10).set_delay(time*10)
	startAlarm(time*20)

func interPoolShake(time:int):
	var porc:float= float(time)/100.00 
	var porcForce=forceShake/100
	cameraOrigin.camera.zoom= cameraOrigin.zoom - (dirShake.abs() *porc*porcForce*cameraOrigin.zoom)
	var offsetFinal=Vector2.ZERO
	var posVar:Vector2=Vector2(randf_range( - forceShake, forceShake),randf_range( - forceShake, forceShake))
	var zoomVar:Vector2= Vector2(randf_range( - forceShake/700, forceShake/700),randf_range( - forceShake/700, forceShake/700))
	#print(zoomX)
	cameraOrigin.zoom+ zoomVar
	var offsetCalcOrg=Vector2.ZERO
	if(dirShake.x>0):
		offsetCalcOrg.x=(1/cameraOrigin.zoom.x-1)*-1152
		offsetFinal.x= (1/cameraOrigin.camera.zoom.x-1)*-1152
		offsetFinal.x-=offsetCalcOrg.x
	if(dirShake.y>0):
		offsetCalcOrg.y=(1/cameraOrigin.zoom.y-1)*-648		
		offsetFinal.y= (1/cameraOrigin.camera.zoom.y-1)*-648
		offsetFinal.y-=offsetCalcOrg.y
	offsetFinal+=posVar
	offset=offsetFinal

func startAlarm(time:float):
	var timer = get_tree().create_timer(time)
	timer.connect("timeout", _on_Timer_timeout);

func get_active_camera()-> camera2dInfo:
	var max=0
	var cameraReturn:camera2dInfo
	for camera in General.currentLevel.listPhamToCamera:
		if camera.camera.priority>max:
			cameraReturn=camera
			max=camera.camera.priority
			
	return cameraReturn
