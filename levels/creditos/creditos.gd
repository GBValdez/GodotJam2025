extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/ColorRect.visible=true
	modifyBlack(0,1)
	General.createTimer(5,_showTwo)
	
func _showTwo():
	modifyBlack(1,0.5)
	General.createTimer(0.5,_showTwoNow)

func _showTwoNow():
	General.go_to_level("res://Levels/MenuPrincipal/menu_principal.tscn")
	

func modifyBlack(a:float,time:float):
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property($CanvasLayer/ColorRect,"color",Color(0,0,0,a),time)
	

func endTween():
	General.go_to_level("res://Levels/MenuPrincipal/menu_principal.tscn")
