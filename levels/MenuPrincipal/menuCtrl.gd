extends menuCtrl

			
func _readyAux() -> void:
	selectItem(0)

func setOptions():
	match (currentOpt):
		0:
			General.go_to_level("res://levels/level1/level1.tscn")
		1:
			General.go_to_level("res://levels/creditos/creditos.tscn")
		2:
			General.go_to_level("")
