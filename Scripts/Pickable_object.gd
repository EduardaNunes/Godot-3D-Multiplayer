class_name PickableObject
extends RigidBody3D

var price : int = 1
var shader_material : ShaderMaterial = null
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision: CollisionShape3D = $CollisionShape3D

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	var material : ShaderMaterial = mesh.material_overlay
	shader_material = material.duplicate()
	mesh.material_overlay = shader_material

# ---------------------------------------------------------------------------- #

func get_focus():
	shader_material.set_shader_parameter("renderOutline", true)

# ---------------------------------------------------------------------------- #

func loose_focus():
	shader_material.set_shader_parameter("renderOutline", false)

# ---------------------------------------------------------------------------- #

func pick_up(parent : Node3D):
	if not parent:
		return
	reparent(parent)
	position = Vector3.ZERO
	collision.disabled = true
	freeze = true

# ---------------------------------------------------------------------------- #

func throw(direction : Vector3):
	reparent(get_tree().current_scene)
	collision.disabled = false
	freeze = false
	apply_impulse(direction * 10)

# ---------------------------------------------------------------------------- #
