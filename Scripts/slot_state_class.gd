extends Node
class_name slotState

var num_of_pucks : int
var top_puck_id  : int

func _init(_slot_index:int) -> void:
	#print("slotState init called")
	if _slot_index == 0:
		num_of_pucks = 3
		top_puck_id  = 1
	else:
		num_of_pucks = 0
		top_puck_id  = 0		
