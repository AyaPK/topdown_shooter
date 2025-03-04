extends Node

var hp = 5

func get_hit() -> void:
	hp -= 1
	Hud.hp.text = str(hp)
