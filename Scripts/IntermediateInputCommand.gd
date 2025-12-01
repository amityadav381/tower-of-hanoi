extends Node
class_name IntermediateInputCommand

#X co-ordinate is slot, Y co-ordinate is height. Both 1 indexed
var slot_from :int
var slot_to   :int
var move_index:int

func _ready() -> void:
	slot_from  = 0
	slot_to    = 0
	move_index = 0
