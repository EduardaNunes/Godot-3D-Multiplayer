extends CharacterBody3D

var speed = 5.0
var direction : Vector3

@onready var model: Node3D = $godot_plush_model
@onready var animation: AnimationPlayer = $godot_plush_model/AnimationPlayer
@onready var camera: Camera3D = $CameraPosition/Camera3D

@export var color : String
var animation_direction : Vector3 = Vector3.ZERO

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
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
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
