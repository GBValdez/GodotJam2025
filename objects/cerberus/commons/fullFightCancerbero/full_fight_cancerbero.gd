extends Node2D
var cancerberos:Array=[
	preload("res://objects/cerberus/electric/electricController.tscn"),
	preload("res://objects/cerberus/water/waterController.tscn"),
	preload("res://objects/cerberus/fire/fireController.tscn"),
]
var current=null
func _process(delta: float) -> void:
	if current==null and General.fase<cancerberos.size():
		current= General.addNode(cancerberos[General.fase],Vector2.ZERO)

	
