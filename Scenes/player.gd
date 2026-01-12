extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75

func _physics_process(delta):
	var direction = Vector3.ZERO
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	print('x: ', input_direction.x, ' | y: ', input_direction.y )
	
	# get the relative direction from where the player is looking
	direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()

	if not is_on_floor():
		velocity.y -= fall_acceleration * delta
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		# slow movement stop
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
