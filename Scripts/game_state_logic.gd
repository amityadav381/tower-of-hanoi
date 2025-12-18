extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func processIICommand(_cmd:IntermediateInputCommand)->bool:
	
	#VALIDATE THE INPUT
	if GameInitModule.gameState[_cmd.slot_from].size() == 0:
		#print("ILLEGAL MOVE")
		return false
	elif ((GameInitModule.gameState[_cmd.slot_to].size() != 0) and \
	(GameInitModule.gameState[_cmd.slot_from].back() > GameInitModule.gameState[_cmd.slot_to].back())):
		#print("ILLEGAL MOVE")
		return false
	
	#PROCESS THE COMMAND
	#print("IC RECEIVED")
	var ic := InputCommand.new()
	ic.is_right           = _cmd.slot_to > _cmd.slot_from
	ic.slot_to            = _cmd.slot_to
	ic.move_index         = _cmd.move_index
	ic.puck_id            = GameInitModule.gameState[_cmd.slot_from].pop_back()
	ic.puck_position_to   = \
		Vector2(_cmd.slot_to, GameInitModule.gameState[_cmd.slot_to].size())
	
	
	#if (GameInitModule.inputCommands.is_empty()):  
		#get_parent().inputCommandPopulated.emit()
	
	#PUSH THE COMMAND TO QUEUE
	GameInitModule.inputCommands.push_back(ic)
	#print("IC PUSHED TO ANI-SYS")
	
	#UPDATE GAME STATE
	GameInitModule.gameState[_cmd.slot_to].push_back(ic.puck_id)
	#print("UPDATED GAME STATE = ", GameInitModule.gameState)

	return true
