extends PathFollow2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)


func start_animating_path()->void:
	progress_ratio = 0
	set_physics_process(true)

func animation_ended()->void:
	set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	progress_ratio += 0.2
	if progress_ratio >= 1:
		animation_ended()
	
