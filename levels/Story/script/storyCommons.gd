extends Node2D
class_name storyCommons
var visible_characters = 0
var time_on_end = 1
var max_chars = 106
var sections = []
var current_index = 0
var waiting = false
var special_chars = ["\n"]  
var char_velocity = 0.009;
@export() var dialog:String=""
signal finishScene
func _ready() -> void:
	var textElement:Label=$Text
	#textElement.text=dialog
	sections = assign_text()
	%Text1_animation.speed_scale = 1.0 / (sections[current_index].length() * char_velocity)
	%RichTextLabel.text = sections[current_index]
	await get_tree().process_frame
	%RichTextLabel.visible_characters = 0

	
func _process(delta: float) -> void:
	if visible_characters != $%RichTextLabel.visible_characters:
		visible_characters = $%RichTextLabel.visible_characters
		$AudioStreamPlayer2D.play()
	if !waiting and %RichTextLabel.visible_characters == -1:
		waiting = true
		await get_tree().create_timer(time_on_end).timeout
		show_next_text()
		

func assign_text():
	var text= tr(dialog)
	var words = text.split(" ")
	var result: Array = []
	var actual_line := ""

	for word in words:
		var special_char = false
		for character in special_chars:
			if character in word:
				special_char = true
				break

		# Si agregar esta palabra excede el límite, guardar y reiniciar línea
		if (actual_line.length() + word.length() + 1) > max_chars:
			result.append(actual_line.strip_edges())
			actual_line = ""
		actual_line += word + " "
		if special_char:
			result.append(actual_line.strip_edges())
			actual_line = ""
	if actual_line.strip_edges() != "":
		result.append(actual_line.strip_edges())
	return result

func show_next_text():
	current_index += 1
	if current_index < sections.size():
		%RichTextLabel.bbcode_enabled = false
		%RichTextLabel.text = sections[current_index]
		%Text1_animation.speed_scale = 1.0 / (sections[current_index].length() * char_velocity)
		%RichTextLabel.visible_characters = 0
		$Text1_animation.play("Text")
		visible_characters = 0
		waiting = false
	else:
		_endAnimation()
		General.createTimer(2,_endScene)
func _endScene():
	finishScene.emit()
	queue_free()
func _endAnimation():
	pass
