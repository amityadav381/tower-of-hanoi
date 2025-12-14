extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_jumping :bool = false


func initiate_jump2()->void:
	is_jumping = true
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	# Handle jump.
	if is_jumping:
		print("jumped_2")
		velocity.y = JUMP_VELOCITY
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
