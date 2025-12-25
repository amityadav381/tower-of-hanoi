extends PathFollow2D

@export var puck_ref  : CharacterBody2D
@export var flip_anim : Curve
@onready var remote_transform := $RemoteTransform2D
var puck_weight : int = 0
var is_right :bool = true
var slot_to  : int = 0

signal animation_ended(_slot_to : int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)

func startFollowing(_p_w: int, _is_right:bool, _slot_to : int)->void:
	#print("--entered startFollowing --")
	#print("--progress_ratio = ",progress_ratio)
	puck_weight = _p_w
	is_right    = _is_right
	slot_to     = _slot_to
	set_physics_process(true)
	
func reachedEnd()->void:
	set_physics_process(false)
	
func _physics_process(_delta: float) -> void:
	progress_ratio += 0.04
	if progress_ratio >= 0.60:
		progress_ratio += 0.06
	if is_right:
		puck_ref.rotation = flip_anim.sample(progress_ratio) - 0.5
	else:
		puck_ref.rotation = 0.5 - flip_anim.sample(progress_ratio)
	#print("progress_ratio body = \n",progress_ratio)
	#print("sample = ", flip_anim.sample(progress_ratio))
		
	if progress_ratio >= 1:
		reachedEnd()
		animation_ended.emit(slot_to)
