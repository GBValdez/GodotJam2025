extends Node2D
class_name storyCommons

var visible_characters := 0
var time_on_end := 1.05
var max_chars := 165
var sections: Array = []
var current_index := 0
var waiting := false
var char_velocity := 0.009
var timeSleep := 0.0
var _type_time := 0.0
var _is_typing := false
var _last_sound_character := 0
var _sound_players: Array[AudioStreamPlayer2D] = []
var _sound_player_index := 0
var _advance_started := false

@export() var dialog: String = ""
signal finishScene

const TEXT_MARGIN_X := 54.0
const TEXT_BOTTOM_MARGIN := 22.0
const TEXT_HEIGHT := 126.0
const READ_CHARS_PER_SECOND := 20.0
const SOUND_PLAYER_COUNT := 5

func _ready() -> void:
	get_viewport().size_changed.connect(_apply_layout)
	_apply_layout()
	var textElement := get_node_or_null("Text") as Label
	if textElement != null:
		textElement.text = dialog
	sections = assign_text()
	if sections.is_empty():
		sections.append("")
	_setup_type_sounds()
	$Text1_animation.stop()
	_set_current_text()

func _process(delta: float) -> void:
	_update_typewriter(delta)
	if Input.is_action_just_pressed("ui_action"):
		_finish_current_text()
		_start_advance_timer(1.15)
	if Input.is_action_pressed("ui_action"):
		timeSleep += delta
		if timeSleep > 3.0:
			_endScene()
	else:
		timeSleep = 0.0

func assign_text():
	var translated_text := tr(dialog).replace("\r\n", "\n").replace("\r", "\n")
	var result: Array = []
	var paragraphs := translated_text.split("\n", false)
	for paragraph in paragraphs:
		var clean_paragraph := String(paragraph).strip_edges()
		if clean_paragraph == "":
			continue
		_add_paragraph_sections(clean_paragraph, result)
	return result

func _add_paragraph_sections(paragraph: String, result: Array) -> void:
	var sentences := _split_sentences(paragraph)
	var current := ""
	for sentence in sentences:
		var sentence_text := String(sentence)
		if sentence_text.length() > max_chars:
			if current != "":
				result.append(current)
				current = ""
			_add_long_sentence_sections(sentence_text, result)
			continue
		var candidate: String
		if current == "":
			candidate = sentence_text
		else:
			candidate = current + " " + sentence_text
		if candidate.length() > max_chars and current != "":
			result.append(current)
			current = sentence_text
		else:
			current = candidate
	if current != "":
		result.append(current)

func _split_sentences(text: String) -> Array:
	var sentences: Array = []
	var current := ""
	for i in text.length():
		var character := text.substr(i, 1)
		current += character
		if character == "." or character == "!" or character == "?" or character == ":" or character == ";":
			var clean := current.strip_edges()
			if clean != "":
				sentences.append(clean)
			current = ""
	var remaining := current.strip_edges()
	if remaining != "":
		sentences.append(remaining)
	return sentences

func _add_long_sentence_sections(sentence: String, result: Array) -> void:
	var words := sentence.split(" ", false)
	var current := ""
	for word in words:
		var word_text := String(word)
		var candidate: String
		if current == "":
			candidate = word_text
		else:
			candidate = current + " " + word_text
		if candidate.length() > max_chars and current != "":
			result.append(current)
			current = word_text
		else:
			current = candidate
	if current != "":
		result.append(current)

func show_next_text():
	current_index += 1
	if current_index < sections.size():
		_set_current_text()
	else:
		_endAnimation()
		General.createTimer(2, _endScene)

func _set_current_text() -> void:
	waiting = false
	_advance_started = false
	visible_characters = 0
	_type_time = 0.0
	_last_sound_character = 0
	_is_typing = true
	var text_box: RichTextLabel = %RichTextLabel
	_configure_text_box(text_box)
	text_box.text = String(sections[current_index])
	text_box.visible_ratio = 1.0
	text_box.visible_characters = 0

func _configure_text_box(text_box: RichTextLabel) -> void:
	text_box.bbcode_enabled = false
	text_box.scroll_following = false
	text_box.scroll_active = false
	text_box.fit_content = false
	text_box.set("visible_characters_behavior", 1)

func _update_typewriter(delta: float) -> void:
	if !_is_typing:
		return
	var text_length: int = String(sections[current_index]).length()
	_type_time += delta
	var next_visible := int(_type_time * READ_CHARS_PER_SECOND)
	if next_visible > text_length:
		next_visible = text_length
	if next_visible != visible_characters:
		visible_characters = next_visible
		%RichTextLabel.visible_characters = visible_characters
		_play_type_sound(visible_characters)
	if visible_characters >= text_length:
		_finish_current_text()
		_start_advance_timer(time_on_end)

func _play_type_sound(new_visible_characters: int) -> void:
	if new_visible_characters <= _last_sound_character:
		return
	var text: String = String(sections[current_index])
	var typed_character: String = text.substr(new_visible_characters - 1, 1)
	_last_sound_character = new_visible_characters
	if typed_character == " " or typed_character == "\n" or typed_character == "\t":
		return
	var player := _sound_players[_sound_player_index]
	_sound_player_index = (_sound_player_index + 1) % _sound_players.size()
	player.stop()
	player.play()

func _setup_type_sounds() -> void:
	_sound_players.clear()
	var original := $AudioStreamPlayer2D as AudioStreamPlayer2D
	_sound_players.append(original)
	for i in range(SOUND_PLAYER_COUNT - 1):
		var player := AudioStreamPlayer2D.new()
		player.name = "TypeSound" + str(i + 2)
		player.stream = original.stream
		player.volume_db = original.volume_db
		player.pitch_scale = original.pitch_scale
		add_child(player)
		_sound_players.append(player)

func _finish_current_text() -> void:
	if waiting:
		return
	_is_typing = false
	waiting = true
	visible_characters = String(sections[current_index]).length()
	%RichTextLabel.visible_characters = -1

func _start_advance_timer(delay: float) -> void:
	if _advance_started:
		return
	_advance_started = true
	await get_tree().create_timer(delay).timeout
	if waiting:
		show_next_text()

func _endScene():
	finishScene.emit()

func _endAnimation():
	pass

func _apply_layout() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var background := get_node_or_null("CanvasLayer/ColorRect") as ColorRect
	if background != null:
		background.set_anchors_preset(Control.PRESET_FULL_RECT)
		background.offset_left = 0
		background.offset_top = 0
		background.offset_right = 0
		background.offset_bottom = 0
	var text_box := get_node_or_null("CanvasLayer/RichTextLabel") as RichTextLabel
	if text_box != null:
		_configure_text_box(text_box)
		text_box.offset_left = TEXT_MARGIN_X
		var right_edge := viewport_size.x - TEXT_MARGIN_X
		if right_edge < TEXT_MARGIN_X + 32.0:
			right_edge = TEXT_MARGIN_X + 32.0
		text_box.offset_right = right_edge
		text_box.offset_bottom = viewport_size.y - TEXT_BOTTOM_MARGIN
		text_box.offset_top = text_box.offset_bottom - TEXT_HEIGHT
	var sprite := get_node_or_null("CanvasLayer/AnimatedSprite2D") as AnimatedSprite2D
	if sprite != null:
		var text_top := viewport_size.y - TEXT_BOTTOM_MARGIN - TEXT_HEIGHT
		var sprite_y := text_top * 0.52
		if sprite_y < 66.0:
			sprite_y = 66.0
		sprite.position = Vector2(viewport_size.x * 0.5, sprite_y)
