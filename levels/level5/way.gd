extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func upPresed(body: Node2D) -> void:
	configure("1",false)
	print("hola")
	pass # Replace with function body.


func upDelease(body: Node2D) -> void:
	General.createTimer(1.3,configure.bind("1",true))
	pass # Replace with function body.


func downPressed(body: Node2D) -> void:
	configure("2",false)
	pass # Replace with function body.


func downDelease(body: Node2D) -> void:
	General.createTimer(1.3,configure.bind("2",true))
	

func configure(section:String,enable:bool):
	var nodes:Array[Node]=get_node(section).get_children()
	for node in nodes:
		var elect:electricity= node
		if enable:
			elect.setOn()
		else:
			elect.setOff()
