extends Node2D

@export var speed: float = 3000.0  # Bullet speed
@export var max_distance: float = 2000.0  # Bullet range
@export var color: Color = Color(1, 1, 0)  # Yellow color for the bullet

var start_position: Vector2
var end_position: Vector2
var hit_position: Vector2
var hit_something: bool = false
var direction: Vector2

func _ready():
	start_position = global_position  # Bullet starts at player's position
	direction = (get_global_mouse_position() - start_position).normalized()  # Calculate direction
	end_position = start_position + direction * max_distance  # Set the end point of the line
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_position, end_position)
	query.collide_with_bodies = true
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)

	if result:
		hit_something = true
		hit_position = result.position
		if result.collider.is_in_group("enemies"):
			result.collider.queue_free()  # Destroy enemy
	else:
		hit_position = end_position  # No hit, bullet reaches max range

	queue_redraw()  # Redraw line
	await get_tree().create_timer(0.05).timeout  # Bullet lifetime
	queue_free()

func _draw():
	# Draw a line from start position to hit position
	draw_line(Vector2.ZERO, to_local(hit_position), color, 2)
