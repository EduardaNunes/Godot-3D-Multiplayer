extends Camera3D

const camera_sens: float = 0.003

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("esc"): get_tree().quit()
	
	if event is InputEventMouseMotion:
		# rotate the player horizontaly
		get_parent().rotate_y(-event.relative.x * camera_sens)
		# rotate the camera verticaly
		rotation.x -= event.relative.y * camera_sens
		# set max up and down vision area
		rotation.x = clamp(rotation.x, deg_to_rad(-89), deg_to_rad(89))
