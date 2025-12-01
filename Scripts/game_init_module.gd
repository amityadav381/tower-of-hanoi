extends Node

@export var inputCommands : Array[InputCommand]
#@export var intermediateInputCommands :Array[IntermediateInputCommand]
#@export var gameState := gameStateClass.new()
@export var gameState :Array[Array] #= [[2,1,0],[],[]]
@export var target_slot :int #= 2

#signal gameStateReady

enum puck_t
{
	PUCK1 = 1,
	PUCK2,
	PUCK3,
	MAX_PUCKS = PUCK3,	
}

enum slot_t
{
	SLOT1 = 1,
	SLOT2,
	SLOT3,
	MAX_SLOTS = SLOT3
}

func _ready() -> void:
	#print("SINGLETON IS READY")
	#print(gameState)
	inputCommands.clear()
	#intermediateInputCommands.clear()
	#await get_tree().create_timer(5).timeout
	#This should be emitted after the table and puck scene is loaded :(
	#gameStateReady.emit()
	gameInitState()
	
	#print("GAME STATE AT INIT = ",gameState)
	#print("TARGET SLOT (zero indexed) = ", target_slot)

func gameInitState()->void:
	gameState = [[],[],[]]
	for _puck in range((puck_t.MAX_PUCKS-1), -1, -1):
		var _slot :int = randi_range(0, 2)
		gameState[_slot].push_back(_puck)
	target_slot = randi_range(0, 2)
	
func connectToAniSys()->void:
	get_node("../Main/TableAndPuck").animationCompleted.connect(on_animation_completed)

func on_animation_completed()->void:
	if gameState[target_slot].size() == 3:
		print("!!!WIN!!!")
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
