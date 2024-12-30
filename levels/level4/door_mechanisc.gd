extends Node

func validate():
	if(one and two):
		get_parent().open()
	else:
		get_parent().close()

var one:bool=false
var two:bool=false

func _on_button_press_signal(body: Node2D) -> void:
	one=true
	validate()


func _on_button_delease_signal(body: Node2D) -> void:
	one=false
	validate()
	


func _on_button_2_press_signal(body: Node2D) -> void:
	two=true
	validate()
	

func _on_button_2_delease_signal(body: Node2D) -> void:
	two=false
	validate()
	
