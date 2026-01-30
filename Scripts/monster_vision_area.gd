extends Area3D

signal player_spotted(player: CharacterBody3D)
signal player_lost

#@onready var ray_cast: RayCast3D = $"../RayCast3D"
var player: CharacterBody3D = null

# ---------------------------------------------------------------------------- #

#func _physics_process(_delta: float) -> void:
	#if not multiplayer.is_server() or player == null:
		#return

	#ray_cast.look_at(player.global_position + Vector3.UP, Vector3.UP)
	#ray_cast.force_raycast_update()

	#if ray_cast.is_colliding() and ray_cast.get_collider() == player:
		#player_spotted.emit(player)
	#else:
		#player_lost.emit()

# ---------------------------------------------------------------------------- #

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body != get_parent():
		player = body as CharacterBody3D
		player_spotted.emit(player)

# ---------------------------------------------------------------------------- #

func _on_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
		player_lost.emit()
		
# ---------------------------------------------------------------------------- #
