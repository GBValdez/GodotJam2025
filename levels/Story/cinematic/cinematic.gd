extends storyGroup
func _ready() -> void:
	scenes=[
		load("res://levels/Story/stories/story_7/story_7.tscn"),
		load("res://levels/Story/stories/story_8/story_8.tscn"),
		load("res://levels/Story/stories/story_9/story_9.tscn"),
		load("res://levels/Story/stories/story_10/story_10.tscn"),
		load("res://levels/Story/stories/story_11/story_11.tscn")
	]
	super._ready()
func endScenes():
	get_tree().change_scene_to_file("res://levels/level1/level1.tscn")
