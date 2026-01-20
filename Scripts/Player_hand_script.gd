class_name PlayerHand
extends Area3D

var object_list : Array[PickableObject] = []
@onready var hand_node: Marker3D = $"../godot_plush_model/HandPosition"

var focus_object : PickableObject = null
var picked_object: PickableObject = null

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	body_entered.connect(_object_entered)
	body_exited.connect(_object_exited)

# ---------------------------------------------------------------------------- #

func _object_entered(body : Node3D):
	var object : PickableObject = body as PickableObject
	if object == null:
		return
	object_list.append(object)

# ---------------------------------------------------------------------------- #

func _object_exited(body : Node3D):
	var object : PickableObject = body as PickableObject
	if object == null:
		return
	object_list.erase(object)
	if object_list.is_empty() and focus_object != null:
		focus_object.loose_focus()

# ---------------------------------------------------------------------------- #

func get_nearest_object() -> PickableObject:
	var min_dist : float = INF
	var nearest_object : PickableObject = null
	for obj in object_list:
		var new_dist = obj.global_position.distance_squared_to(hand_node.global_position)
		if new_dist < min_dist:
			nearest_object = obj
			min_dist = new_dist
	return nearest_object

# ---------------------------------------------------------------------------- #

func set_focus_on_nearest_object():
	if object_list.is_empty():
		return
	if focus_object:
		focus_object.loose_focus()
	focus_object = get_nearest_object()
	if focus_object: 
		focus_object.get_focus()

# ---------------------------------------------------------------------------- #

func pick_focus_item():
	focus_object.pick_up(hand_node)
	picked_object = focus_object

# ---------------------------------------------------------------------------- #

func throw_item(direction : Vector3):
	picked_object.throw(direction)
	picked_object = null

# ---------------------------------------------------------------------------- #

func interact(direction : Vector3):
	if focus_object == null:
		return
	if picked_object == null:
		pick_focus_item()
	else:
		throw_item(direction)

# ---------------------------------------------------------------------------- #
