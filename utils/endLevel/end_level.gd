extends Area2D
@export var redirectLevel:String=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered",enter)
	connect("area_entered",enterArea2D)
func enter(body:Node2D):
	if(body.get_parent().is_in_group("player")):
		General.go_to_level(redirectLevel)


func enterArea2D(body:Area2D):
	if(body.get_parent().is_in_group("player")):
		General.go_to_level(redirectLevel)		
