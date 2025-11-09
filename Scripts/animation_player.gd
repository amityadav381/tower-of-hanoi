extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed_scale = 1

func play_anim()->void:
	play("m1_to_m3")


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
