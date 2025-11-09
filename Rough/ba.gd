extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func called_by_aa()->void:
	print("Entered BA")
	#var i = 100
	#while i>0:
		#i -= 1
	await get_tree().create_timer(2.0).timeout
	print("Exited BA")
