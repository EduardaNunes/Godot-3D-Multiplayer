class_name PlayerHand
extends Area3D

var object_list : Array[PickableObject] = []
@onready var hand_node: Marker3D = $"../HandPosition"

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

# ---------------------------------------------------------------------------- #

func get_nearest_object() -> PickableObject:
	var min_dist : float = INF
	var nearest_object : PickableObject = object_list[0]
	for obj in object_list:
		var new_dist = obj.global_position.distance_squared_to(hand_node.global_position)
		if new_dist < min_dist:
			nearest_object = obj
			min_dist = new_dist
	return nearest_object

# ---------------------------------------------------------------------------- #
