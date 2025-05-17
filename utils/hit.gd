extends Area2D
class_name Hit
@export_category("Config")
@export_group("general")
@export var hit: int = 1;
@export var force:float =200;
@export var forceHit:bool=false;
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", enter_hit)

func enter_hit(body: Node2D):
	if (body.is_in_group("player")):
		var entityBody = body as Entity
		entityBody.hitDamage(hit, global_position,force,forceHit)
	pass # Replace with function body.
