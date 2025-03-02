class_name Level extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() <= 0:
		get_tree().quit()
