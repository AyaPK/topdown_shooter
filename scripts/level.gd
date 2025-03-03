class_name Level extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() <= 0:
		_change_level()

func _change_level() -> void:
	LevelTracker.level += 1
	var new_level ="res://levels/level_"+str(LevelTracker.level)+".tscn"
	
	get_tree().change_scene_to_file(new_level)
