extends CharacterBody3D

var speed = 5.0
var direction : Vector3
var looking_direction : Vector3

@onready var collision : CollisionShape3D = $CollisionShape3D
@onready var model: Node3D = $godot_plush_model
@onready var animation: AnimationPlayer = $godot_plush_model/AnimationPlayer
@onready var camera: Camera3D = $CameraPosition/Camera3D
@onready var player_hand: PlayerHand = $ObjectArea

@export var color : String
var animation_direction : Vector3 = Vector3.FORWARD

# ---------------------------------------------------------------------------- #

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

# ---------------------------------------------------------------------------- #

func _physics_process(delta: float) -> void:
	
	if not multiplayer.has_multiplayer_peer(): return
	if not is_multiplayer_authority(): return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		looking_direction = direction
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		player_hand.set_focus_on_nearest_object()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	_update_animation()
	move_and_slide()

# ---------------------------------------------------------------------------- #

func _update_animation():
	if velocity.length() != 0:
		animation.play("run")
		if animation_direction != direction:
			animation_direction = direction
			var look_at_position := model.global_position - direction
			model.look_at(look_at_position)
	else:
		animation.play("idle")

# ---------------------------------------------------------------------------- #

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		player_hand.interact(looking_direction)

# ---------------------------------------------------------------------------- #

@rpc("any_peer", "call_local", "reliable")
func set_dead_state():
	set_physics_process(false)
	set_process(false)
	collision.disabled = true
	collision_layer = 0
	collision_mask = 0
	hide()
