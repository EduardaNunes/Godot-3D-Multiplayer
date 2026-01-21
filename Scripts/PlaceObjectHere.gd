extends Area3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	body_entered.connect(obj_entered)

# ---------------------------------------------------------------------------- #

func obj_entered(obj : Node3D):
	var pickable_object : PickableObject = obj as PickableObject
	if not pickable_object:
		return
	pickable_object.queue_free()
	animation_player.stop()
	animation_player.play("SquashStretch")

# ---------------------------------------------------------------------------- #
