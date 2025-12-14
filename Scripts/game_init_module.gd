extends Node

@export var inputCommands : Array[InputCommand]
#@export var intermediateInputCommands :Array[IntermediateInputCommand]
#@export var gameState := gameStateClass.new()
@export var gameState :Array[Array] #= [[2,1,0],[],[]]
@export var target_slot :int #= 2
@export var gameWon : bool = false

@export var move_count_main := 0
@export var time_taken_main := 0.0

var gameStatePreserve :Array[Array]

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
	inputCommands.clear()
	#intermediateInputCommands.clear()
	#await get_tree().create_timer(5).timeout
	#This should be emitted after the table and puck scene is loaded :(
	#gameStateReady.emit()
	move_count_main = 0
	time_taken_main = 0.0
	gameInitState()
	#print("GAME STATE AT INIT = ",gameState)
	#print("TARGET SLOT (zero indexed) = ", target_slot)

func gameInitState()->void:
	move_count_main = 0
	time_taken_main = 0.0
	gameState = [[],[],[]]
	for _puck in range((puck_t.MAX_PUCKS-1), -1, -1):
		var _slot :int = randi_range(0, 2)
		gameState[_slot].push_back(_puck)
	gameStatePreserve = gameState.duplicate(true)
	target_slot = randi_range(0, 2)

func gameInitAtRestart()->void:
	move_count_main = 0
	time_taken_main = 0
	gameState       = gameStatePreserve.duplicate(true)
	
func connectToAniSys()->void:
	print("Ani-Sys connected to Autoload")
	get_node("../Main/TableAndPuck").animationCompleted.connect(on_animation_completed)

func connectToCountDownNode()->void:
	print("CountDown node connected to Autoload")
	get_node("../Main/CountDownWindow").count_down_over.connect(on_count_down_over)

func connectToMainGameLoaded()->void:
	print("Main node connected to Autoload")
	get_node("../Main")._tree_entered.connect(on_main_node_entered)

func connectTablePuckAnimationDone()->void:
	print("tablePuckAnimationDone connected to Autoload")
	get_node("../Main/TableAndPuck").tablePuckAnimationDone.connect(on_table_puck_animation_complete)

func connectRestartRequested()->void:
	print("RestartRequested connected to Autoload")
	get_node("../Main/GameScoreWindow").gameRestartReq.connect(on_gameRestartReq_sent)

func connectNextGameRequested()->void:
	print("connectNextGameRequested to Autoload")
	get_node("../Main/GameScoreWindow").nextGameRreq.connect(on_nextGameRreq_sent)

func on_nextGameRreq_sent()->void:
	get_node("../Main/TableAndPuck").makePuckInvisible()
	get_node("../Main/TableAndPuck").placePucksInResetPosition()
	get_node("../Main/GameScoreWindow").visible = false
	get_node("../Main/BlurAnimation").play("RESET")
	gameInitState()
	get_node("../Main/ICGS").reset_ingame_counters()
	on_main_node_entered()

func on_gameRestartReq_sent()->void:
	get_node("../Main/TableAndPuck").makePuckInvisible()
	get_node("../Main/TableAndPuck").placePucksInResetPosition()
	get_node("../Main/GameScoreWindow").visible = false
	get_node("../Main/BlurAnimation").play("RESET")
	gameInitAtRestart()
	get_node("../Main/ICGS").reset_ingame_counters()
	on_main_node_entered()

func on_animation_completed()->void:
	if (gameState[target_slot].size() == 3) && (GameInitModule.inputCommands.size() == 0):
		print("!!!WIN!!!")
		gameWon = true
		get_node("../Main/ICGS").disable_user_inputs()
		get_node("../Main/ICGS").start_game_score_timer(false)
		get_node("../Main/GameScoreWindow").update_score_board(time_taken_main, move_count_main)
		get_node("../Main/GameScoreWindow").visible = true
		get_node("../Main/BlurAnimation").play("blur_animation")

func on_main_node_entered()->void:
	print("on_main_node_entered")
	get_node("../Main/ICGS").disable_user_inputs()
	get_node("../Main/TableAndPuck").play_initial_puck_slot_animation()
	

func on_count_down_over()->void:
	print("on_count_down_over")
	#Here I need to start the game timer and enable user input.
	#Upto this point no user inputs should be allowed.
	get_node("../Main/CountDownWindow").visible = false
	get_node("../Main/ICGS").enable_user_inputs()
	#get_node("../Main/ICGS").start_game_score_timer(true)

func on_table_puck_animation_complete()->void:
	get_node("../Main/CountDownWindow").start_count_down()
