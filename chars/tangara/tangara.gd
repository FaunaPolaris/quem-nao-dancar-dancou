extends CharacterBody2D


@export var speed = 450.0
@export_range(0, 1) var acceleration = 1.0
@export_range(0, 1) var deceleration = 0.05
@export var jumpVelocity = -700.0
@export_range(0, 1) var decelerateOnJumpRelease = 0.01

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerateOnJumpRelease
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deceleration)

	move_and_slide()
