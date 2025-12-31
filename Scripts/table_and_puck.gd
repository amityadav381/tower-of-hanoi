extends Node

@onready var path := $Path2D
@onready var pathFollow2D := $Path2D/PathFollow2D
@onready var remoteTransform := $Path2D/PathFollow2D/RemoteTransform2D
#var puck1 = null #$Puck1
#var puck2 = null #$Puck2
#var puck3 = null #$Puck3
#Directly make an array of pucks
@export var puck_scene :PackedScene

@onready var AP    := $AnimationPlayer

@onready var table  := $Table_0
@onready var table2 := $Table_1
@onready var table3 := $Table_2
@onready var slot0_mrkr := $Table_0/Slot0
@onready var slot1_mrkr := $Table_1/Slot1
@onready var slot2_mrkr := $Table_2/Slot2
#Markers for all possible PUCK locations

@onready var mrkr_10 := $Table_0/M10
@onready var mrkr_11 := $Table_0/M11
@onready var mrkr_12 := $Table_0/M12
@onready var mrkr_13 := $Table_0/M13
@onready var mrkr_14 := $Table_0/M14
@onready var mrkr_15 := $Table_0/M15
@onready var mrkr_16 := $Table_0/M16


@onready var mrkr_20 := $Table_1/M20
@onready var mrkr_21 := $Table_1/M21
@onready var mrkr_22 := $Table_1/M22
@onready var mrkr_23 := $Table_1/M23
@onready var mrkr_24 := $Table_1/M24
@onready var mrkr_25 := $Table_1/M25
@onready var mrkr_26 := $Table_1/M26


@onready var mrkr_30 := $Table_2/M30
@onready var mrkr_31 := $Table_2/M31
@onready var mrkr_32 := $Table_2/M32
@onready var mrkr_33 := $Table_2/M33
@onready var mrkr_34 := $Table_2/M34
@onready var mrkr_35 := $Table_2/M35
@onready var mrkr_36 := $Table_2/M36


@export var time_elapsed := 0.0

@export var puckObjects    : Array = []
@export var puckPosition   : Array = []
@export var slots_Array    : Array = []
@export var slotTableArray : Array = []

@onready var puck_jump_audio := $PuckJump
@onready var puck_land_audio := $PuckLand
@onready var game_win_audio  := $GameWinSound
var table_anim_callback    : Array
var _input_command : InputCommand

var slot_highlight_shader      = preload("res://Resources/diagonal_lines.gdshader")
var slot_highlight_material    = ShaderMaterial.new()
var _t                        := 0.0

var puck_counter := 0

signal animationCompleted
signal tablePuckAnimationDone

var slotPanelTheme    :Theme    = preload("res://Resources/slot_theme.tres")
var styleBox          :StyleBox = slotPanelTheme.get_stylebox("panel", "Panel")
#var styleBoxWhite     := styleBox.duplicate(true)
#@export var inputCommands : Array[InputCommand]


func createCommandForTest()->void:
	var cmd  := InputCommand.new()
	#CMD0
	#cmd.puck_position_from = mrkr_11.position
	#cmd.puck_position_to   = mrkr_23.position
	cmd.puck_position_to   = Vector2(1,0)
	#cmd.puck_id            = puckObjects[0]
	cmd.puck_id            = 0
	cmd.move_index         = 1
	#inputCommands.push_back(cmd)

	
	var cmd1  := InputCommand.new()
	#CMD1
	#cmd1.puck_position_from = mrkr_12.position
	#cmd1.puck_position_to   = mrkr_33.position
	cmd1.puck_position_to   = Vector2(2,0)
	#cmd1.puck_id            = puckObjects[1]
	cmd1.puck_id            = 1
	cmd1.move_index         = 2
	#inputCommands.push_back(cmd1)

	
	var cmd2  := InputCommand.new()
	#CMD3
	#cmd2.puck_position_from = mrkr_23.position
	#cmd2.puck_position_to   = mrkr_12.position
	cmd2.puck_position_to   = Vector2(0,1)
	#cmd2.puck_id            = puckObjects[0]
	cmd2.puck_id            = 0
	cmd2.move_index         = 3
	#inputCommands.push_back(cmd2)
	
	var cmd3  := InputCommand.new()
	#CMD3
	#cmd3.puck_position_from = mrkr_33.position
	#cmd3.puck_position_to   = mrkr_11.position
	cmd3.puck_position_to   = Vector2(0,2)
	#cmd3.puck_id            = puckObjects[1]
	cmd3.puck_id            = 1
	cmd3.move_index         = 4
	#inputCommands.push_back(cmd3)

	#print("CMDS0=",inputCommands[0])
	#print("CMDS1=",inputCommands[1])
	#print("CMDS2=",inputCommands[2])

func makePuckVisible()->void:
	for i in GameInitModule.PUCK_COUNT_1INDEXD: 
		puckObjects[i].visible = true

#func makePuckInvisible()->void:
	#for i in range(3): #MAX PUCKS
		#puckObjects[i].visible = false

func placePucksInResetPosition()->void:
	#for i in range(GameInitModule.PUCK_COUNT_1INDEXD): #MAX PUCKS
	print("placePucksInResetPosition puck_counter = ", puck_counter)
	if puck_counter >= GameInitModule.PUCK_COUNT_1INDEXD:
		printerr("Weird Puck count")
	puckObjects.append(puck_scene.instantiate())
	puckObjects[puck_counter].global_position = Vector2(-50, 100) #Vector2(-50 - (45*puck_counter), 100) #Vector2(270 - (45*i), 200) #
	puckObjects[puck_counter].name = "Puck"+str(puck_counter)
	add_child(puckObjects[puck_counter])
	puckObjects[puck_counter].set_the_puck_visual_size(puck_counter)
	puck_counter += 1

func resetTargetSlotVisual()->void:
	#print("ALL SLOT VISUAL RESETTED")
	for _s in range(3):
		#print("SLOT RESETTED = ", _s)
		slots_Array[_s].material = null
		slots_Array[_s].theme.set_stylebox("panel", "Panel", styleBox)
	slot_highlight_material.shader = slot_highlight_shader
	slot_highlight_material.set_shader_parameter("stripe_width", 0.25)
	slot_highlight_material.set_shader_parameter("angle", 0.785)
	#slot_highlight_material.set_shader_parameter("color_a", Color(0.03, 0.10, 0.22, 1.00))
	#slot_highlight_material.set_shader_parameter("color_b", Color(0, 0, 0, 1.00))
	slot_highlight_material.set_shader_parameter("color_a", Color(0.906, 0.325, 0.184, 1.0))
	slot_highlight_material.set_shader_parameter("color_b", Color(0.98, 0.941, 0.894, 1.0))

func visualizeTargetSlot()->void:
	#print("TARGET SLOT VISUALIZED = ", GameInitModule.target_slot)
	slots_Array[GameInitModule.target_slot].material = slot_highlight_material

func freeAllPucks()->void:
	for i in range(GameInitModule.PUCK_COUNT_1INDEXD):
		if puckObjects.size():
			puckObjects[i].queue_free()
			print("PUCKS FREED = ", i)
	puckObjects.clear()

func selectTargetSlot(_bigPuckSlot: int)->void:
	var _add :int = randi_range(1,2)
	var _tS  :int = _bigPuckSlot + _add
	if _tS > 2: #MAX 3 slots only
		_tS = _tS%3
	GameInitModule.target_slot = _tS
	GameInitModule.target_slot_perserve = GameInitModule.target_slot
	visualizeTargetSlot()

func calculateGameIndex()->void:
	GameInitModule.gameIndex = 0
	var temp_game_state :Array = GameInitModule.gameState_slotPreserve.duplicate(true)
	for i in GameInitModule.PUCK_COUNT_1INDEXD:
		GameInitModule.gameIndex += (temp_game_state.pop_front())*(3**i)
		#print("DEBUG calculateGameIndex = ", temp_game_state)
	GameInitModule.gameIndex_preserve = GameInitModule.gameIndex
	
	if temp_game_state.size() != 0:
		printerr("SOMWTHING WRONG WITH THE GAME STATE CALCULATIONS!!")

func startNewGame()->void:
	#print("NEW GAME")
	#GameInitModule.gameState_slotPreserve.clear()
	#GameInitModule.gameClearState()
	for _p in range((GameInitModule.PUCK_COUNT_1INDEXD-1), -1, -1):
		placePucksInResetPosition()
		var _s :int = randi_range(0,2) #Fixed number of slots
		if puck_counter == 1:
			selectTargetSlot(_s)
		GameInitModule.gameState_slotPreserve.push_back(_s)
		#print("DEBUG startNewGame = ", GameInitModule.gameState_slotPreserve)
		await animatingThePucks(_s)
		#GameInitModule.gameState[_s].push_back(puck_counter - 1)
		#pathFollow2D.puck_ref = puckObjects[puck_counter - 1]
		#path.curve = createParabolaCurve(puckObjects[puck_counter - 1].global_position, puckPosition[_s][GameInitModule.gameState[_s].size() -1])
		#remoteTransform.remote_path = puckObjects[puck_counter - 1].get_path()
		#pathFollow2D.progress_ratio = 0
		##print("START FOLLOWING THE CURVE TO SLOT = ",_s)
		#pathFollow2D.startFollowing(0, true, _s)
		#await(pathFollow2D.animation_ended)
		#table_anim_callback[_s].call()
		#await(AP.animation_finished)
	#tablePuckAnimationDone.emit()

func restartLastGame()->void:
	#print("LAST PLAYED GAME")
	visualizeTargetSlot()
	#GameInitModule.gameInitAtRestart()
	for _p in range((GameInitModule.PUCK_COUNT_1INDEXD-1), -1, -1):
		placePucksInResetPosition()
		#print("GameInitModule.gameState_slot = ", GameInitModule.gameState_slot)
		var _s :int = GameInitModule.gameState_slot.pop_front()
		#GameInitModule.gameStatePreserve.push_back(_s)
		await animatingThePucks(_s)
		#GameInitModule.gameState[_s].push_back(puck_counter - 1)
		#pathFollow2D.puck_ref = puckObjects[puck_counter - 1]
		#path.curve = createParabolaCurve(puckObjects[puck_counter - 1].global_position, puckPosition[_s][GameInitModule.gameState[_s].size() -1])
		#remoteTransform.remote_path = puckObjects[puck_counter - 1].get_path()
		#pathFollow2D.progress_ratio = 0
		##print("START FOLLOWING THE CURVE TO SLOT = ",_s)
		#pathFollow2D.startFollowing(0, true, _s)
		#await(pathFollow2D.animation_ended)
		#table_anim_callback[_s].call()
		#await(AP.animation_finished)
	#tablePuckAnimationDone.emit()

func animatingThePucks(_s: int)->void:
	GameInitModule.gameState[_s].push_back(puck_counter - 1)
	pathFollow2D.puck_ref = puckObjects[puck_counter - 1]
	#print("GameInitModule.gameState[_s] = ", _s ,GameInitModule.gameState[_s])
	path.curve = createParabolaCurve(puckObjects[puck_counter - 1].global_position, puckPosition[_s][GameInitModule.gameState[_s].size() -1])
	remoteTransform.remote_path = puckObjects[puck_counter - 1].get_path()
	pathFollow2D.progress_ratio = 0
	#print("START FOLLOWING THE CURVE TO SLOT = ",_s)
	pathFollow2D.startFollowing(0, true, _s)
	puck_jump_audio.play()
	await(pathFollow2D.animation_ended)
	puck_land_audio.play()
	table_anim_callback[_s].call()
	await(AP.animation_finished)
#func gameInitState()->void:
	#move_count_main = 0
	#time_taken_main = 0.0
	#gameState = [[],[],[]]
	#for _puck in range((PUCK_COUNT_1INDEXD-1), -1, -1):
		#var _slot :int = randi_range(0, 2)
		#gameState[_slot].push_back(_puck)
	#gameStatePreserve = gameState.duplicate(true)
	#target_slot = randi_range(0, 2)
	#minMoveCount = calculate_min_moves(gameState, target_slot)
	
func onGameStateReady()->void:
	puck_counter = 0
	print("puck_counter ZEROED!")
	if GameInitModule.gameStartState == GameInitModule.GameStart.NEW_GAME:
		GameInitModule.gameClearState()
		await startNewGame()
		calculateGameIndex()
	else:
		await restartLastGame()
	tablePuckAnimationDone.emit()
	#slots_Array[GameInitModule.target_slot].theme.set_stylebox("panel", "Panel", styleBoxWhite)
	#GameInitModule.gameInitState()
	#for _p in range((GameInitModule.PUCK_COUNT_1INDEXD-1), -1, -1):
		#placePucksInResetPosition()
		#var _s :int = randi_range(0,2) #Fixed number of slots
		#if puck_counter == 1:
			#selectTargetSlot(_s)
		#GameInitModule.gameStatePreserve.push_back(_s)
		#GameInitModule.gameState[_s].push_back(puck_counter - 1)
		#pathFollow2D.puck_ref = puckObjects[puck_counter - 1]
		#path.curve = createParabolaCurve(puckObjects[puck_counter - 1].global_position, puckPosition[_s][GameInitModule.gameState[_s].size() -1])
		#remoteTransform.remote_path = puckObjects[puck_counter - 1].get_path()
		#pathFollow2D.progress_ratio = 0
		##print("START FOLLOWING THE CURVE TO SLOT = ",_s)
		#pathFollow2D.startFollowing(0, true, _s)
		#await(pathFollow2D.animation_ended)
		#table_anim_callback[_s].call()
		#await(AP.animation_finished)
	#tablePuckAnimationDone.emit()

	#runICQCommands()
	#await get_tree().create_timer(0.1).timeout
	#makePuckVisible()

func extractCommandFromCommandArray()->InputCommand:
	if not GameInitModule.inputCommands.is_empty():
		return GameInitModule.inputCommands.front()
	else:
		return null

func placingPucks()->void:
	puckPosition = \
	[
		[
			mrkr_16.global_position,
			mrkr_15.global_position,
			mrkr_14.global_position,
			mrkr_13.global_position,
			mrkr_12.global_position,
			mrkr_11.global_position,
			mrkr_10.global_position
		],
		[
			mrkr_26.global_position,
			mrkr_25.global_position,
			mrkr_24.global_position,
			mrkr_23.global_position,
			mrkr_22.global_position,
			mrkr_21.global_position,
			mrkr_20.global_position
		],
		[
			mrkr_36.global_position,
			mrkr_35.global_position,
			mrkr_34.global_position,
			mrkr_33.global_position,
			mrkr_32.global_position,
			mrkr_31.global_position,
			mrkr_30.global_position
		]
	]
	#puckObjects = \
	#[
		#puck1,
		#puck2,
		#puck3
	#]
	slots_Array = \
	[
		slot0_mrkr,
		slot1_mrkr,
		slot2_mrkr
	]
	slotTableArray = \
	[
		table,
		table2,
		table3
	]
	table_anim_callback = \
	[
		AP.play_animation_table0,
		AP.play_animation_table1,
		AP.play_animation_table2
	]

func _ready() -> void:
	#print("Table and Puck node loaded")
	placingPucks()
	#placePucksInResetPosition()
	resetTargetSlotVisual()
	#slot_highlight_material.shader = slot_highlight_shader
	#slot_highlight_material.set_shader_parameter("stripe_width", 0.25)
	#slot_highlight_material.set_shader_parameter("angle", 0.785)
	#slot_highlight_material.set_shader_parameter("color_a", Color(0.03, 0.10, 0.22, 1.00))
	##slot_highlight_material.set_shader_parameter("color_a", Color(1, 1, 1, 1.00))
	#slot_highlight_material.set_shader_parameter("color_b", Color(0, 0, 0, 1.00))
	#GameInitModule.gameStateReady.connect(onGameStateReady)
	get_node("../ICGS").inputCommandPopulated.connect(runICQCommands)
	GameInitModule.connectToAniSys()
	GameInitModule.connectTablePuckAnimationDone()
	#styleBoxWhite.border_color   = Color.WHITE
	
	#onGameStateReady()
	#createCommandForTest()

func play_initial_puck_slot_animation()->void:
	#print("play_initial_puck_slot_animation")
	AP.play_reset_all()
	AP.play_initialization_animation()

func _process(delta: float) -> void:
	#print("location of M11 = ", mrkr_11.global_position)
	_t += delta
	slot_highlight_material.set_shader_parameter("time", _t)

func animateCommand()->void:
	_input_command = extractCommandFromCommandArray()
	if _input_command != null:
		var _pid = _input_command.puck_id
		var _pto = _input_command.puck_position_to
		pathFollow2D.puck_ref = puckObjects[_pid]
		path.curve = createParabolaCurve(puckObjects[_pid].global_position,\
		puckPosition[_pto.x][_pto.y])
		#print("PUCK JUMP TO = ", puckPosition[_pto.x][_pto.y])
		remoteTransform.remote_path = await puckObjects[_pid].get_path()
		pathFollow2D.progress_ratio = 0
		#await get_tree().create_timer(1.5).timeout
		#print("ANIMATION STARTED! _pid = ", _pid)
		puck_jump_audio.play()
		pathFollow2D.startFollowing(_pid+1, _input_command.is_right, _input_command.slot_to)

func runICQCommands()->void:
	animateCommand()

func createParabolaCurve(_from_mrkr:Vector2, _to_mrkr:Vector2)-> Curve2D:
	var temp_curve = Curve2D.new()
	#print("\ncurv:_from_mrkr", _from_mrkr)
	#print("curv:_to_mrkr", _to_mrkr)
	temp_curve.add_point(_from_mrkr, Vector2.ZERO, Vector2(0,-150))
	temp_curve.add_point(_to_mrkr, Vector2(0,-200), Vector2.ZERO)
	
	return temp_curve

func _on_path_follow_2d_animation_ended(_slot_to : int) -> void:
	puck_land_audio.play()
	if puck_counter < GameInitModule.PUCK_COUNT_1INDEXD:
		return
	#print("ANIMATION ENDED!")
	#slotTableArray[_input_command.slot_to].applyImpulseToTable(_puck_weight)
	#print("_input_command.slot_to = ",_slot_to)
	table_anim_callback[_slot_to].call()
	#animationCompleted.emit()
	#await table_anim_callback[_slot_to].call()
	#animationCompleted.emit()
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#print("IS PUCK ANIMATION ENDING????? = ", anim_name)
	if anim_name == "initialization_animation":
		#print("---tablePuckAnimationDone---")
		onGameStateReady()
	elif (anim_name == "table_0") or (anim_name == "table_1") or (anim_name == "table_2"):
		animationCompleted.emit()
