extends PathFollow2D

@export var puck_ref  : CharacterBody2D
@export var flip_anim : Curve
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)

func start_following()->void:
	set_physics_process(true)
	
func reached_end()->void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	progress_ratio += 0.01
	if progress_ratio >= 0.60:
		progress_ratio += 0.04
	
	puck_ref.rotation = flip_anim.sample(progress_ratio) - 0.5
	print("progress_ratio = \n",progress_ratio)
	print("sample = ", flip_anim.sample(progress_ratio))
		
	if progress_ratio == 1:
		reached_end()
