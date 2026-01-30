class_name PickableObject
extends RigidBody3D

var price : int = 1
var shader_material : ShaderMaterial = null
var mesh : MeshInstance3D = null
@onready var collision: CollisionShape3D = $CollisionShape3D
#wdd@onready var objects_pool : Node3D = self.get_parent()
const OUTLINE_MATERIAL_OVERLAY = preload("uid://cher62svvssyn")

@export var mesh_list : Array[StringName] = [
	"res://Assets/Decoracao/barrel_small.gltf",
	"res://Assets/Decoracao/barrel_small_stack.gltf",
	"res://Assets/Decoracao/bottle_A_green.gltf",
	"res://Assets/Decoracao/bottle_A_brown.gltf",
	"res://Assets/Decoracao/bottle_B_brown.gltf",
	"res://Assets/Decoracao/bottle_B_green.gltf",
	"res://Assets/Decoracao/box_large.gltf",
	"res://Assets/Decoracao/box_small.gltf",
	"res://Assets/Decoracao/box_small_decorated.gltf",
	"res://Assets/Decoracao/chair.gltf",
	"res://Assets/Decoracao/chest.gltf",
	"res://Assets/Decoracao/chest_gold.gltf",
	"res://Assets/Decoracao/coin_stack_medium.gltf",
	"res://Assets/Decoracao/coin_stack_small.gltf",
	"res://Assets/Decoracao/crates_stacked.gltf"
]

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	$MeshInstance3D.queue_free()
	var mesh_scene_path = mesh_list.pick_random()
	var mesh_scene : PackedScene = load(mesh_scene_path)
	var mesh_scene_node = mesh_scene.instantiate()
	add_child(mesh_scene_node)
	
	mesh = mesh_scene_node.get_child(0)
	shader_material = OUTLINE_MATERIAL_OVERLAY.duplicate()
	mesh.material_overlay = shader_material
	set_multiplayer_authority(name.to_int())

# ---------------------------------------------------------------------------- #

func get_focus():
	shader_material.set_shader_parameter("renderOutline", true)

# ---------------------------------------------------------------------------- #

func loose_focus():
	shader_material.set_shader_parameter("renderOutline", false)

# ---------------------------------------------------------------------------- #

@rpc("any_peer", "call_local", "reliable")
func pick_up(hand_node_path : NodePath):
	var new_parent = get_node(hand_node_path)
	if not new_parent: return
	
	set_multiplayer_authority(new_parent.get_multiplayer_authority())
	
	reparent(new_parent)
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	collision.disabled = true
	freeze = true


@rpc("any_peer", "call_local", "reliable")
func throw(direction : Vector3):
	set_multiplayer_authority(1)
	
	reparent(get_tree().current_scene.get_node("Objects")) 
	collision.disabled = false
	freeze = false
	apply_impulse(direction * 10)
	#var rotation_vector : Vector3 = direction.rotated(Vector3.UP, deg_to_rad(90))
	#apply_torque(rotation_vector * 3)

# ---------------------------------------------------------------------------- #

#func throw(direction : Vector3):
	#reparent(get_tree().current_scene)
	#collision.disabled = false
	#freeze = false
	#apply_impulse(direction * 10)
	#var rotation_vector : Vector3 = direction.rotated(Vector3.UP, deg_to_rad(90))
	#apply_torque(rotation_vector * 3)

# ---------------------------------------------------------------------------- #
