extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play_animation_table0()->void:
	play("table_0")

func play_animation_table1()->void:
	play("table_1")

func play_animation_table2()->void:
	play("table_2")

func play_initialization_animation()->void:
	play("initialization_animation")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
