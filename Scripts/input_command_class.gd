extends Node
class_name InputCommand

#X co-ordinate is slot, Y co-ordinate is height. Both 1 indexed
var puck_position_from:Vector2
var puck_position_to:Vector2
var puck_id: CharacterBody2D
var move_index:int

func _ready() -> void:
	puck_position_from = Vector2.ZERO
	puck_position_to = Vector2.ZERO
	puck_id = null
	move_index = 0
