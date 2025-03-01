extends CharacterBody2D

@export var speed: float = 300.0  # Max speed
@export var acceleration: float = 20.0  # Acceleration rate
@export var friction: float = 15.0  # Deceleration rate

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
