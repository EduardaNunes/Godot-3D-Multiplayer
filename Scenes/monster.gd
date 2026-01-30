extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var vision_area : Area3D = $VisionArea
@export var speed: float = 3.0
@export var gravity: float = 9.8

var follow_points: Array[Node]
var player_in_range : CharacterBody3D

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	follow_points = get_parent().get_node('MonsterFollowPoints').get_children()
	vision_area.player_spotted.connect(_on_player_spotted)
	vision_area.player_lost.connect(_on_player_lost)

# ---------------------------------------------------------------------------- #

func _on_player_spotted(player : CharacterBody3D) -> void:
	player_in_range = player

# ---------------------------------------------------------------------------- #

func _on_player_lost() -> void:
	player_in_range = null

# ---------------------------------------------------------------------------- #

func _physics_process(delta: float):
	
	if not multiplayer.is_server(): return
	
	# --- Gravidade --- #
	if not is_on_floor(): velocity.y -= gravity * delta
	else: velocity.y = -0.1
	# ----------------- #
	
	if player_in_range:
		nav_agent.target_position = player_in_range.global_position
	else:
		if nav_agent.is_navigation_finished() and not follow_points.is_empty():
			nav_agent.target_position = follow_points.pick_random().global_position
	
	if not nav_agent.is_navigation_finished():
		var next_path_pos = nav_agent.get_next_path_position()
		var current_pos = global_position
		var direction = (next_path_pos - current_pos)
		direction.y = 0 
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# --- Rotação --- #
		if velocity.length() > 0.2:
			var target_rotation = atan2(-velocity.x, -velocity.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, delta * 10.0)
		# --------------- #
	move_and_slide()

# ---------------------------------------------------------------------------- #
