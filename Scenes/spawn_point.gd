extends Area3D

func _on_body_exited(body: Node3D) -> void:
	print(body.name)
	if body is CharacterBody3D:
		body.set_collision_mask_value(2, true)
