extends Node

@onready var ba = $"../../B/BA"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Entered AA")
	
	await get_tree().create_timer(2.0).timeout
	ba.called_by_aa()
	print("Exited AA")
