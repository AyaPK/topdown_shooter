extends CharacterBody2D

@export var speed: float = 300.0  # Max speed
@export var acceleration: float = 20.0  # Acceleration rate
@export var friction: float = 15.0  # Deceleration rate
@export var bullet_scene: PackedScene
@onready var gunpoint: Node2D = $gunpoint

func _physics_process(delta):
	# Get Input Direction
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Apply acceleration if moving, otherwise apply friction
	if input_vector.length() > 0:
		velocity = velocity.lerp(input_vector * speed, acceleration * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)

	# Rotate to face the mouse
	look_at(get_global_mouse_position())

	# Apply movement
	move_and_slide()
	
	queue_redraw()

func _input(event):
	if event.is_action_pressed("shoot"):
		fire_bullet()

func _draw():
	if get_tree().debug_collisions_hint:
		draw_line(Vector2.ZERO, to_local(get_global_mouse_position()), Color.RED, 2)

func fire_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = gunpoint.global_position
	get_parent().add_child(bullet)
