extends Sprite2D
class_name attack_bar
var matStuffed:ShaderMaterial
var total:float=0

func _ready() -> void:
	matStuffed=$stuffed.material
	
func setCant(sum:float):
	var tween:Tween= get_tree().create_tween()
	if total<1:
		tween.tween_method(modBar,total,total+sum,0.05);	
		total+=sum

func empty():
	var tween:Tween= get_tree().create_tween()
	tween.tween_method(modBar,total,0,0.1);
	total=0
	
func modBar(count:float):
	matStuffed.set_shader_parameter("fill_amount",count)
	if count>=1:
		$full.visible=true
	else:
		$full.visible=false
