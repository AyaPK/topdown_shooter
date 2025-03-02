extends Sprite2D

const CROSSHAIR = preload("res://art/characters/crosshair.png")
const CROSSHAIR_RED = preload("res://art/characters/crosshair_red.png")
var space_state

func _ready():
	space_state = get_world_2d().direct_space_state
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	z_index = 100

func _process(_delta):
	global_position = get_global_mouse_position()
	check_enemy_under_cursor()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		global_position = event.position

func check_enemy_under_cursor():
	if not space_state:
		return
	
	# Use `intersect_point()` to check if the cursor is over an enemy
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collide_with_areas = true  # If enemies use Area2D, this is needed
	query.collide_with_bodies = true  # If enemies use CharacterBody2D or RigidBody2D
	
	var results = space_state.intersect_point(query)

	# Check if any of the detected objects are enemies
	var hovering_enemy = false
	for result in results:
		if result.collider.is_in_group("enemies"):
			hovering_enemy = true
			break

	if  hovering_enemy:
		texture = CROSSHAIR_RED
	else:
		texture = CROSSHAIR
