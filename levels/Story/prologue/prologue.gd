extends storyGroup
func _ready() -> void:
	scenes=[
		load("res://levels/Story/stories/story_1/story_1.tscn"),
		load("res://levels/Story/stories/story_2/story_2.tscn"),
		load("res://levels/Story/stories/story_3/story_3.tscn"),
		load("res://levels/Story/stories/story_4/story_4.tscn"),
		load("res://levels/Story/stories/story_5/story_5.tscn"),
		load("res://levels/Story/stories/story_6/story_6.tscn"),
	]
	super._ready()
func endScenes():
	get_tree().change_scene_to_file("res://levels/Tutorial/Tutorial.tscn")
