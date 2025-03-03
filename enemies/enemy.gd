extends CharacterBody2D

@export var vision_angle: float = 45.0 
@export var vision_range: float = 500.0
@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 1.0
@export var reaction_time: float = 1.0

@onready var gunpoint: Node2D = $Gunpoint

var player: Node2D
var can_shoot: bool = true
var is_detecting_player: bool = false
var detection_timer: float = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	add_to_group("enemies")

func _physics_process(delta):
	if player:
		var direction_to_player = player.global_position - global_position
		
		if direction_to_player.length() <= vision_range:
			look_at(player.global_position)
			
			var angle_to_player = rad_to_deg(global_position.angle_to_point(player.global_position))
			var current_rotation_deg = rad_to_deg(rotation)
			var angle_diff = abs(angle_to_player - current_rotation_deg)
			
			angle_diff = min(angle_diff, 360 - angle_diff)
			
			if angle_diff <= vision_angle / 2:
				var space_state = get_world_2d().direct_space_state
				var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
				query.exclude = [self]
				
				var result = space_state.intersect_ray(query)
				
				if not result or result.collider == player:
					if not is_detecting_player:
						is_detecting_player = true
						detection_timer = 0.0
					
					detection_timer += delta
					
					if detection_timer >= reaction_time:
						attempt_shoot()
				else:
					is_detecting_player = false
					detection_timer = 0.0
			else:
				is_detecting_player = false
				detection_timer = 0.0

func attempt_shoot():
	if can_shoot:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = gunpoint.global_position
		bullet.direction = (player.global_position - global_position).normalized()
		get_parent().add_child(bullet)
		
		can_shoot = false
		await get_tree().create_timer(shoot_cooldown).timeout
		can_shoot = true
