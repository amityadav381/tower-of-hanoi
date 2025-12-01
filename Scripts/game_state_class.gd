extends Node
class_name gameStateClass

var slot_state : Array[slotState] = [slotState.new(0), slotState.new(1), slotState.new(2)]

func _init() -> void:
	pass
	#print("gameStateClass init called")
	#print("NUMBER OF SLOTS in GAME = ", slot_state.size())
	
