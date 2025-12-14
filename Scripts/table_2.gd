extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyImpulseToTable(_weight: int)->void:
	self.apply_central_impulse(Vector2(0,200*_weight))
