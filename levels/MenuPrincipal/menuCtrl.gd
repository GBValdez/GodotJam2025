extends menuCtrl

			
func _readyAux() -> void:
	selectItem(0)
	TranslationServer.set_locale("en")

func setOptions():
	match (currentOpt):
		0:
			General.go_to_level("res://levels/Story/prologue/prologue.tscn")
		1:
			General.go_to_level("res://levels/creditos/creditos.tscn")
		2:
			General.go_to_level("")
