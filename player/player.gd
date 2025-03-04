extends CharacterBody2D

@export var speed: float = 300.0 
@export var acceleration: float = 20.0
@export var friction: float = 15.0
@export var bullet_scene: PackedScene
@onready var gunpoint: Node2D = $gunpoint
@onready var timer: Timer = $Timer

var walking: bool = false

func _ready() -> void:
	timer.timeout.connect(_on_footstep_timeout)

func _physics_process(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector.length() > 0:
		velocity = velocity.lerp(input_vector * speed, acceleration * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)
	look_at(get_global_mouse_position())

	move_and_slide()
	
	queue_redraw()

func _input(event):
	if event.is_action_pressed("shoot"):
		fire_bullet()

func _on_footstep_timeout() -> void:
	if velocity.x > 100 or velocity.y > 100 or velocity.x < -100 or velocity.y < -100:
		AudioManager.player_footstep.play()
	timer.start()

func _draw():
	if get_tree().debug_collisions_hint:
		draw_line(Vector2.ZERO, to_local(get_global_mouse_position()), Color.RED, 2)

func fire_bullet():
	AudioManager.player_gunshot.play()
	var bullet = bullet_scene.instantiate()
	bullet.global_position = gunpoint.global_position
	get_parent().add_child(bullet)
