extends PathFollow2D

@export var puck_ref  : CharacterBody2D
@export var flip_anim : Curve
@onready var remote_transform := $RemoteTransform2D

signal animation_ended
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)

func startFollowing()->void:
	set_physics_process(true)
	
func reachedEnd()->void:
	set_physics_process(false)
	
func _physics_process(_delta: float) -> void:
	progress_ratio += 0.03
	if progress_ratio >= 0.60:
		progress_ratio += 0.04
	
	puck_ref.rotation = flip_anim.sample(progress_ratio) - 0.5
	#print("progress_ratio = \n",progress_ratio)
	#print("sample = ", flip_anim.sample(progress_ratio))
		
	if progress_ratio >= 1:
		animation_ended.emit()
		reachedEnd()
