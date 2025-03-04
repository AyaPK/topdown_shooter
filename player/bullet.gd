extends Node2D

@export var speed: float = 3000.0
@export var max_distance: float = 2000.0
@export var color: Color = Color(1, 1, 0)

var start_position: Vector2
var end_position: Vector2
var hit_position: Vector2
var hit_something: bool = false
var direction: Vector2

func _ready():
	start_position = global_position
	direction = (get_global_mouse_position() - start_position).normalized()
	end_position = start_position + direction * max_distance
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_position, end_position)
	query.collide_with_bodies = true
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)

	if result:
		hit_something = true
		hit_position = result.position
		if result.collider.is_in_group("enemies"):
			result.collider.queue_free()
			AudioManager.robot_dead.play()
	else:
		hit_position = end_position

	queue_redraw()
	await get_tree().create_timer(0.05).timeout
	queue_free()

func _draw():
	draw_line(Vector2.ZERO, to_local(hit_position), color, 2)
