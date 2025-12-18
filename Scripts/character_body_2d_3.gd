extends CharacterBody2D



func _ready() -> void:
	#visible = false
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
	move_and_slide()
