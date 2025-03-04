extends CanvasLayer
@onready var hp: Label = $hp

func _ready() -> void:
	hp.text = str(PlayerTracker.hp)
