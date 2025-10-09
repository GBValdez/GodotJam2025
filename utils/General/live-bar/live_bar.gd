extends Node2D
class_name  LiveBar

var life:float=0;
var matLiveReal:ShaderMaterial
var matLife:ShaderMaterial
func _ready() -> void:
	matLiveReal= $live.material
	matLife= $reallive.material

func start(newLife:float):
	life=newLife;	
	matLife.set_shader_parameter("totalLife",life)
	matLiveReal.set_shader_parameter("totalLife",life)
	hit(0,0)

func hit(damage:float,init:float=-1):
	if init ==-1:
		init=life
	var tweenReal= get_tree().create_tween()
	tweenReal.tween_method(modRealLife,init,life-damage,0.1);	
	var tween= get_tree().create_tween();
	tween.tween_method(modLife,init,life-damage,0.5);
	life-=damage
func modRealLife(count:float):
	matLiveReal.set_shader_parameter("life",count)

func modLife(count:float):
	matLife.set_shader_parameter("life",count)
