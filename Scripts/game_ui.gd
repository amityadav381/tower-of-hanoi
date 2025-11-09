extends Node2D

@onready var character_name = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	character_name.text = "Window Size = " + str(get_tree().root.size) +\
	"\nContent Size = "+ str(get_tree().root.content_scale_size)

	
