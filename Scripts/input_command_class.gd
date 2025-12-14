extends Node
class_name InputCommand

#X co-ordinate is slot, Y co-ordinate is height. Both 1 indexed
#var puck_position_from:Vector2
var puck_position_to  :Vector2
var puck_id           :int
var move_index        :int
var is_right          :bool
var slot_to           :int

func _init() -> void:
	#puck_position_from = Vector2.ZERO
	puck_position_to   = Vector2.ZERO
	puck_id            = 0
	move_index         = 0
	is_right           = false
	slot_to            = 0
