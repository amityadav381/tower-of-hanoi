extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyImpulseToTable(_weight: int)->void:
	self.apply_central_impulse(Vector2(0,200*_weight))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(_delta: float) -> void:
	#if Input.is_action_just_pressed("left_click"):
		#self.apply_central_impulse(Vector2(0,500))
