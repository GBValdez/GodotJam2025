extends Timer
var on:bool=false
var squareBlock:ColorRect
var letters:Array[Node]
var glishSound:AudioStreamPlayer
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	glishSound= get_tree().get_first_node_in_group("glishSound")
	squareBlock= get_tree().get_first_node_in_group("blackSquare")	
	letters= get_tree().get_nodes_in_group("letter") 
	onOff(false)
	#if not FileAccess.file_exists(general.savePath):
	#	general.saveData()
	#var db_music:float= general.dataGame["music_db"]
	#var db_sfx:float= general.dataGame["sfx_db"]
	#setAudio("music",db_music)
	#setAudio("sfx",db_sfx)
	
	
	
	
func setAudio(name:String, db:float):
	var bus_index:int = AudioServer.get_bus_index(name)
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(db)
	)
	
func _process(delta: float) -> void:
	if(not squareBlock.visible and not on):
		onOff(true)
		on=true
		start()
		glishSound.play()


func onOff(op:bool):
	for letter in letters:
			letter.emitting=op


func _on_timeout() -> void:
	onOff(false)
	General.go_to_level("res://levels/MenuPrincipal/menu_principal.tscn")
