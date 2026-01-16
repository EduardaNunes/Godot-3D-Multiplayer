extends Camera3D

@export var camera_anchor : Node3D

@export var distance_treshold : int = 12

func _ready() -> void:
	if not camera_anchor:
		push_error("Camera anchor not found!")

func _process(delta: float) -> void:
	var target_position = camera_anchor.get_global_transform_interpolated().origin
	global_position = global_position.move_toward(target_position, calculate_speed() * delta)

func calculate_speed() -> float:
	# Quero uma velocidade entre [2, 10], de acordo com a distância
	# A função que define isso é: y = ln(x + 1) * 3
	# Estou usando a distância ao quadrado para poupar cálculos
	var distance_to_player = global_position.distance_squared_to(camera_anchor.global_position)
	if distance_to_player > distance_treshold:
		return 10.0
	return log(distance_to_player + 1) * 3
