extends Node

@export var inputCommands : Array[InputCommand]
#@export var intermediateInputCommands :Array[IntermediateInputCommand]
#@export var gameState := gameStateClass.new()
@export var gameState :Array[Array] #= [[2,1,0],[],[]]
@export var target_slot :int #= 2
@export var target_slot_perserve :int
@export var gameWon : bool = false

@export var puck_struct : Array[Array] 
#EXample
#[[2,],[],[]] 3 pucks

@export var PUCK_COUNT_1INDEXD := 0

var minMoveCount := 0
var goldScorepoints := 0.0
var yourPoints := 0.0

@export var move_count_main := 0
@export var time_taken_main := 0.0

var gameState_slotPreserve :Array
var gameState_slot :Array

#signal gameStateReady
enum GameStart {NEW_GAME = 0, RESTART_GAME}
var gameStartState : GameStart

const SAVE_PATH := "user://saved_game_state.tres"
var save_game   :SaveGame = null
#var stateAndScore :GameStateAndScores
var gameIndex : int
var gameIndex_preserve : int

## Computes the minimum number of moves to transfer all disks to the target peg.
## pegs: Array of Arrays, e.g. [[3, 1], [2], []]
## target_peg: The integer ID (0, 1, or 2) of the destination peg.
func calculate_min_moves(pegs: Array[Array], target_peg: int) -> int:
	var disk_pos := {}  # disk -> peg index
	var max_disk := -1
	
	# Record disk positions and find largest disk
	for peg_id in range(3):
		for disk in pegs[peg_id]:
			disk_pos[disk] = peg_id
			max_disk = max(max_disk, disk)
	
	return _min_moves_recursive(max_disk, target_peg, disk_pos)

func _min_moves_recursive(disk: int, target_peg: int, disk_pos: Dictionary) -> int:
	if disk < 0:
		return 0
	
	var current_peg = disk_pos[disk]
	
	# If disk already on target, just solve for smaller disks
	if current_peg == target_peg:
		return _min_moves_recursive(disk - 1, target_peg, disk_pos)
	
	# Find auxiliary peg
	var aux_peg = 3 - current_peg - target_peg
	
	# Moves:
	# 1. Move all smaller disks to aux peg
	var moves := _min_moves_recursive(disk - 1, aux_peg, disk_pos)
	
	# 2. Move this disk to target peg
	moves += 1
	disk_pos[disk] = target_peg
	
	# 3. Move smaller disks from aux peg to target peg
	moves += _min_moves_recursive(disk - 1, target_peg, disk_pos)
	
	return moves



func write_savegame() -> void:
	var error_code := ResourceSaver.save(save_game, SAVE_PATH)
	if error_code != OK:
		push_error("Failed to save game: " + error_string(error_code))
	else:
		print("SAVED SUCCESSFULLY")


func _ready() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		print("FILE DID DO EXIST")
		save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		print("FILE DID NOT EXIST")
		save_game = SaveGame.new()
	
	inputCommands.clear()
	#intermediateInputCommands.clear()
	#await get_tree().create_timer(5).timeout
	#This should be emitted after the table and puck scene is loaded :(
	#gameStateReady.emit()
	move_count_main = 0
	time_taken_main = 0.0
	gameClearState()
	#print("GAME STATE AT INIT = ",gameState)
	#print("TARGET SLOT (zero indexed) = ", target_slot)

func gameClearState()->void:
	move_count_main      = 0
	time_taken_main      = 0.0
	gameIndex            = 0
	gameIndex_preserve   = 0
	gameState            = [[],[],[]]
	minMoveCount         = 0
	target_slot          = 0
	target_slot_perserve = 0
	gameState_slotPreserve.clear()
	gameStartState       = GameStart.NEW_GAME
	#for _puck in range((PUCK_COUNT_1INDEXD-1), -1, -1):
		#var _slot :int = randi_range(0, 2)
		#gameState[_slot].push_back(_puck)
	#gameStatePreserve = gameState.duplicate(true)
	
func cal_minimum_moves_to_win()->void:
	minMoveCount = calculate_min_moves(gameState, target_slot)

func gameInitAtRestart()->void:
	#gameInitState()
	move_count_main  = 0
	time_taken_main  = 0.0
	gameState        = [[],[],[]]
	minMoveCount     = 0
	target_slot      = target_slot_perserve
	gameIndex        = gameIndex_preserve
	gameState_slot   = gameState_slotPreserve.duplicate(true)
	
func connectToAniSys()->void:
	#print("Ani-Sys connected to Autoload")
	get_node("../Main/TableAndPuck").animationCompleted.connect(on_animation_completed)

func connectToCountDownNode()->void:
	#print("CountDown node connected to Autoload")
	get_node("../Main/CountDownWindow").count_down_over.connect(on_count_down_over)

func connectToMainGameLoaded()->void:
	#print("Main node connected to Autoload")
	get_node("../Main")._tree_entered.connect(on_main_node_entered)

func connectTablePuckAnimationDone()->void:
	#print("tablePuckAnimationDone connected to Autoload")
	get_node("../Main/TableAndPuck").tablePuckAnimationDone.connect(on_table_puck_animation_complete)

func connectRestartRequested()->void:
	#print("RestartRequested connected to Autoload")
	get_node("../Main/GameScoreWindow").gameRestartReq.connect(on_gameRestartReq_sent)

func connectNextGameRequested()->void:
	#print("connectNextGameRequested to Autoload")
	get_node("../Main/GameScoreWindow").nextGameRreq.connect(on_nextGameRreq_sent)

func on_nextGameRreq_sent()->void:
	#get_node("../Main/TableAndPuck").makePuckInvisible()
	gameStartState = GameStart.NEW_GAME
	get_node("../Main/TableAndPuck").freeAllPucks()
	get_node("../Main/TableAndPuck").resetTargetSlotVisual()
	#get_node("../Main/TableAndPuck").placePucksInResetPosition()
	get_node("../Main/GameScoreWindow").visible = false
	get_node("../Main/BlurAnimation").play("RESET")
	gameClearState()
	get_node("../Main/ICGS").reset_ingame_counters()
	on_main_node_entered()

func on_gameRestartReq_sent()->void:
	gameStartState = GameStart.RESTART_GAME
	get_node("../Main/TableAndPuck").freeAllPucks()
	get_node("../Main/TableAndPuck").resetTargetSlotVisual()
	#get_node("../Main/TableAndPuck").makePuckInvisible()
	#get_node("../Main/TableAndPuck").placePucksInResetPosition()
	get_node("../Main/GameScoreWindow").visible = false
	get_node("../Main/BlurAnimation").play("RESET")
	gameInitAtRestart()
	get_node("../Main/ICGS").reset_ingame_counters()
	on_main_node_entered()

func on_animation_completed()->void:
	inputCommands.pop_front()
	get_node("../Main/TableAndPuck").animateCommand()
	if gameState[target_slot].size() == PUCK_COUNT_1INDEXD :
		get_node("../Main/ICGS").disable_user_inputs()
		get_node("../Main/ICGS").start_game_score_timer(false)
		updatedSaveGameResources()
		if GameInitModule.inputCommands.size() == 0:
			print("!!!WIN!!!")
			gameWon = true
			#get_node("../Main/BestScorePopUp").visible = false
			yourPoints = time_taken_main + move_count_main
			get_node("../Main/GameScoreWindow").update_score_board(time_taken_main, move_count_main)
			get_node("../Main/BackgroundMusic").stop()
			await get_tree().create_timer(0.5).timeout
			get_node("../Main/TableAndPuck").game_win_audio.play()
			get_node("../Main/GameScoreWindow").visible = true
			get_node("../Main/BlurAnimation").play("blur_animation")

func updatedSaveGameResources()->void:
	if PUCK_COUNT_1INDEXD == 3:
		print("\n\n\n\nsave_game.threePuckTable[gameIndex].bestMoveCount = ", save_game.threePuckTable[gameIndex].bestMoveCount)
		print("move_count_main = ", move_count_main)
		print("gameIndex = ", gameIndex)
		if save_game.threePuckTable[gameIndex].bestMoveCount > move_count_main:
			save_game.threePuckTable[gameIndex].bestMoveCount = move_count_main
			print("!!!!!NEW HIGHER SCORE!!!!!")
		else:
			print("NATCHO BEST SCORE")
		if save_game.threePuckTable[gameIndex].bestTimeTaken > time_taken_main:
			save_game.threePuckTable[gameIndex].bestTimeTaken = time_taken_main
			

		save_game.threePuckTable[gameIndex].gameStatePersist = gameState_slot.duplicate(true)
		save_game.threePuckTable[gameIndex].targetSlotPersist = target_slot
	else:
		if save_game.fourPuckTable[gameIndex].bestMoveCount > move_count_main:
			save_game.fourPuckTable[gameIndex].bestMoveCount = move_count_main
		if save_game.fourPuckTable[gameIndex].bestTimeTaken > time_taken_main:
			save_game.fourPuckTable[gameIndex].bestTimeTaken = time_taken_main
		save_game.fourPuckTable[gameIndex].gameStatePersist = gameState_slot.duplicate(true)
		save_game.fourPuckTable[gameIndex].targetSlotPersist = target_slot
 
	#stateAndScore.bestMoveCount         = move_count_main
	#stateAndScore.bestTimeTaken         = time_taken_main
	#stateAndScore.gameStatePersist      = gameState_slotPreserve.duplicate(true)
	#stateAndScore.targetSlotPersist     = target_slot_perserve
	write_savegame()

func on_main_node_entered()->void:
	print("on_main_node_entered")
	get_node("../Main/BackgroundMusic").play()
	get_node("../Main/ICGS").disable_user_inputs()
	get_node("../Main/TableAndPuck").play_initial_puck_slot_animation()
	

func on_count_down_over()->void:
	print("on_count_down_over")
	#Here I need to start the game timer and enable user input.
	#Upto this point no user inputs should be allowed.
	get_node("../Main/CountDownWindow").visible = false
	#if PUCK_COUNT_1INDEXD == 3:
		#get_node("../Main/BestScorePopUp").update_score_popup\
		#(save_game.threePuckTable[gameIndex].bestTimeTaken, save_game.threePuckTable[gameIndex].bestMoveCount)
	#else:
		#get_node("../Main/BestScorePopUp").update_score_popup\
		#(save_game.fourPuckTable[gameIndex].bestTimeTaken, save_game.fourPuckTable[gameIndex].bestMoveCount)
	print("USER INPUTS ENABLED!")
	get_node("../Main/ICGS").enable_user_inputs()
	#get_node("../Main/ICGS").start_game_score_timer(true)

func on_table_puck_animation_complete()->void:
	get_node("../Main/CountDownWindow").start_count_down()
