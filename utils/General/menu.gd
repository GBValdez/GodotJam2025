class_name menuCtrl

extends VBoxContainer

var audioClick:AudioStreamPlayer
var audioMenu:AudioStreamPlayer
var currentOpt:int=0
var finish:bool=false
var canMove:bool=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audioMenu= get_tree().get_first_node_in_group("soundMenu")
	audioClick= get_tree().get_first_node_in_group("soundMenuClick")
	_readyAux()
func _readyAux() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(not finish):
		if(canMove):
			move()
		accept()

func accept():
	if(Input.is_action_just_pressed("ui_action")):
		finish=true
		setOptions()
		audioClick.play()			
			
func setOptions():
	pass

func move():
	var up:int= 1 if Input.is_action_pressed("ui_up")else 0
	var down:int=1 if Input.is_action_pressed("ui_down") else 0
	if(up!=1 and down!=1):
		return
	canMove=false
	selectItem(currentOpt+down-up)
	var timer= get_tree().create_timer(1)
	timer.connect("timeout",canMoveReturn)
	hover()
	
func selectItem(it:int):
	var anterior= currentOpt
	currentOpt=it
	if(currentOpt<0):
		currentOpt=0
	if(currentOpt>get_child_count()-1):
		currentOpt=get_child_count()-1
	if(anterior!=currentOpt):
		if(!audioMenu.playing):
			audioMenu.pitch_scale=1
			audioMenu.play()
	var count:int=0
	for i in get_children():
		if(count==currentOpt):
			i.modulate= Color(255,255,255,1)
		else:
			i.modulate= Color(255,255,255,0.6)
		count+=1	

func canMoveReturn():
	canMove=true		


func hover():
	pass
