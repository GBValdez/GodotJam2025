extends storyGroup
func _ready() -> void:
	scenes=[
		load("res://levels/Story/stories/story_12/story_12.tscn"),
		load("res://levels/Story/stories/story_13/story_13.tscn")
	]
	super._ready()
func endScenes():
	get_tree().change_scene_to_file("res://levels/creditos/creditos.tscn")
	pass
