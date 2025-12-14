extends Node

@onready var path := $Path2D
@onready var pathFollow2D := $Path2D/PathFollow2D
@onready var remoteTransform := $Path2D/PathFollow2D/RemoteTransform2D
@onready var puck1 := $Puck1
@onready var puck2 := $Puck2
@onready var puck3 := $Puck3
@onready var AP    := $AnimationPlayer

@onready var table  := $Table_0
@onready var table2 := $Table_1
@onready var table3 := $Table_2
@onready var slot0_mrkr := $Table_0/Slot0
@onready var slot1_mrkr := $Table_1/Slot1
@onready var slot2_mrkr := $Table_2/Slot2
#Markers for all possible PUCK locations

@onready var mrkr_11 := $Table_0/M11
@onready var mrkr_12 := $Table_0/M12
@onready var mrkr_13 := $Table_0/M13

@onready var mrkr_21 := $Table_1/M21
@onready var mrkr_22 := $Table_1/M22
@onready var mrkr_23 := $Table_1/M23

@onready var mrkr_31 := $Table_2/M31
@onready var mrkr_32 := $Table_2/M32
@onready var mrkr_33 := $Table_2/M33

@export var time_elapsed := 0.0

@export var puckObjects    : Array = []
@export var puckPosition   : Array = []
@export var slots_Array    : Array = []
@export var slotTableArray : Array = []
var table_anim_callback    : Array
var _input_command : InputCommand

var slot_highlight_shader      = preload("res://Resources/diagonal_lines.gdshader")
var slot_highlight_material    = ShaderMaterial.new()
var _t                        := 0.0

signal animationCompleted
signal tablePuckAnimationDone

var slotPanelTheme    :Theme    = preload("res://Resources/slot_theme.tres")
#var styleBox          :StyleBox = slotPanelTheme.get_stylebox("panel", "Panel")
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
	for i in range(3): #MAX PUCKS
			puckObjects[i].visible = true

func makePuckInvisible()->void:
	for i in range(3): #MAX PUCKS
			puckObjects[i].visible = false

func placePucksInResetPosition()->void:
	for i in range(3): #MAX PUCKS
			puckObjects[i].global_position = Vector2(i*90, -100)
			slots_Array[GameInitModule.target_slot].material = null

func onGameStateReady()->void:
	#slots_Array[GameInitModule.target_slot].theme.set_stylebox("panel", "Panel", styleBoxWhite)
	slots_Array[GameInitModule.target_slot].material = slot_highlight_material
	for _slot in GameInitModule.gameState.size():
		for _puck in GameInitModule.gameState[_slot].size():
			var pos :Vector2 = puckPosition[_slot][_puck]
			var pid :int = GameInitModule.gameState[_slot][_puck]
			puckObjects[pid].global_position = Vector2(pos.x, pos.y - 300)
			#puckObjects[pid].visible = true
			print("OBJECTS PLACED!! = ", puckObjects[pid].global_position)
	#runICQCommands()
	await get_tree().create_timer(0.1).timeout
	makePuckVisible()

func extractCommandFromCommandArray()->InputCommand:
	if not GameInitModule.inputCommands.is_empty():
		return GameInitModule.inputCommands.pop_front()
	else:
		return null

func placingPucks()->void:
	puckPosition = \
	[
		[
			mrkr_13.global_position,
			mrkr_12.global_position,
			mrkr_11.global_position
		],
		[
			mrkr_23.global_position,
			mrkr_22.global_position,
			mrkr_21.global_position
		],
		[
			mrkr_33.global_position,
			mrkr_32.global_position,
			mrkr_31.global_position
		]
	]
	puckObjects = \
	[
		puck1,
		puck2,
		puck3
	]
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
	print("Table and Puck node loaded")
	placingPucks()
	slot_highlight_material.shader = slot_highlight_shader
	slot_highlight_material.set_shader_parameter("stripe_width", 0.25)
	slot_highlight_material.set_shader_parameter("angle", 0.785)
	slot_highlight_material.set_shader_parameter("color_a", Color(0.03, 0.10, 0.22, 1.00))
	#slot_highlight_material.set_shader_parameter("color_a", Color(1, 1, 1, 1.00))
	slot_highlight_material.set_shader_parameter("color_b", Color(0, 0, 0, 1.00))
	#GameInitModule.gameStateReady.connect(onGameStateReady)
	get_node("../ICGS").inputCommandPopulated.connect(runICQCommands)
	GameInitModule.connectToAniSys()
	GameInitModule.connectTablePuckAnimationDone()
	#styleBoxWhite.border_color   = Color.WHITE
	
	#onGameStateReady()
	#createCommandForTest()

func play_initial_puck_slot_animation()->void:
	print("play_initial_puck_slot_animation")
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
		print("PUCK JUMP TO = ", puckPosition[_pto.x][_pto.y])
		remoteTransform.remote_path = puckObjects[_pid].get_path()
		pathFollow2D.progress_ratio = 0
		#await get_tree().create_timer(1.5).timeout
		#print("ANIMATION STARTED! _pid = ", _pid)
		pathFollow2D.startFollowing(_pid+1, _input_command.is_right, _input_command.slot_to)

func runICQCommands()->void:
	animateCommand()

func createParabolaCurve(_from_mrkr:Vector2, _to_mrkr:Vector2)-> Curve2D:
	var temp_curve = Curve2D.new()
	#print("\ncurv:_from_mrkr", _from_mrkr)
	#print("curv:_to_mrkr", _to_mrkr)
	temp_curve.add_point(_from_mrkr, Vector2.ZERO, Vector2(0,-100))
	temp_curve.add_point(_to_mrkr, Vector2(0,-150), Vector2.ZERO)
	
	return temp_curve

func _on_path_follow_2d_animation_ended(_slot_to : int) -> void:
	#print("ANIMATION ENDED!")
	#slotTableArray[_input_command.slot_to].applyImpulseToTable(_puck_weight)
	#print("_input_command.slot_to = ",_slot_to)
	table_anim_callback[_slot_to].call()
	animationCompleted.emit()
	await get_tree().create_timer(0.6).timeout
	animateCommand()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "initialization_animation":
		tablePuckAnimationDone.emit()
