extends Node

@onready var path := $Path2D
@onready var pathFollow2D := $Path2D/PathFollow2D
@onready var remoteTransform := $Path2D/PathFollow2D/RemoteTransform2D
@onready var puck1 := $Puck1
@onready var puck2 := $Puck2
@onready var puck3 := $Puck3

@onready var table := $Table
@onready var slot0_mrkr := $Table/Slot0
@onready var slot1_mrkr := $Table/Slot1
@onready var slot2_mrkr := $Table/Slot2
#Markers for all possible PUCK locations

@onready var mrkr_11 := $Table/M11
@onready var mrkr_12 := $Table/M12
@onready var mrkr_13 := $Table/M13

@onready var mrkr_21 := $Table/M21
@onready var mrkr_22 := $Table/M22
@onready var mrkr_23 := $Table/M23

@onready var mrkr_31 := $Table/M31
@onready var mrkr_32 := $Table/M32
@onready var mrkr_33 := $Table/M33

@export var puckObjects  : Array = []
@export var puckPosition : Array = []
@export var slots_Array  : Array = []
signal animationCompleted

var slotPanelTheme    :Theme    = preload("res://Resources/slot_panels.tres")
var styleBox          :StyleBox = slotPanelTheme.get_stylebox("panel", "Panel")
var styleBoxWhite     := styleBox.duplicate(true)
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

func onGameStateReady()->void:
	slots_Array[GameInitModule.target_slot].theme.set_stylebox("panel", "Panel", styleBoxWhite)
	for _slot in GameInitModule.gameState.size():
		for _puck in GameInitModule.gameState[_slot].size():
			var pos :Marker2D = puckPosition[_slot][_puck]
			var pid :int = GameInitModule.gameState[_slot][_puck]
			puckObjects[pid].position = pos.position
			#print("OBJECTS PLACED!! = ", pos.position)
	#runICQCommands()

func extractCommandFromCommandArray()->InputCommand:
	if not GameInitModule.inputCommands.is_empty():
		return GameInitModule.inputCommands.pop_front()
	else:
		return null

func placingPucks()->void:
	puckPosition = \
	[
		[
			mrkr_13,
			mrkr_12,
			mrkr_11
		],
		[
			mrkr_23,
			mrkr_22,
			mrkr_21
		],
		[
			mrkr_33,
			mrkr_32,
			mrkr_31
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

func _ready() -> void:
	placingPucks()
	#GameInitModule.gameStateReady.connect(onGameStateReady)
	get_node("../ICGS").inputCommandPopulated.connect(runICQCommands)
	GameInitModule.connectToAniSys()
	styleBoxWhite.bg_color   = Color.WHITE
	onGameStateReady()
	#createCommandForTest()

func animateCommand()->void:
	var _input_command = extractCommandFromCommandArray()
	if _input_command != null:
		var _pid = _input_command.puck_id
		var _pto = _input_command.puck_position_to
		pathFollow2D.puck_ref = puckObjects[_pid]
		path.curve = createParabolaCurve(puckObjects[_pid].position,\
		puckPosition[_pto.x][_pto.y].position)
		remoteTransform.remote_path = puckObjects[_pid].get_path()
		pathFollow2D.progress_ratio = 0
		#await get_tree().create_timer(1.5).timeout
		#print("ANIMATION STARTED! _pid = ", _pid)
		pathFollow2D.startFollowing(_pid+1, _input_command.is_right)

func runICQCommands()->void:
	animateCommand()

func createParabolaCurve(_from_mrkr:Vector2, _to_mrkr:Vector2)-> Curve2D:
	var temp_curve = Curve2D.new()
	#print("\ncurv:_from_mrkr", _from_mrkr)
	#print("curv:_to_mrkr", _to_mrkr)
	temp_curve.add_point(_from_mrkr, Vector2.ZERO, Vector2(0,-50))
	temp_curve.add_point(_to_mrkr, Vector2(0,-100), Vector2.ZERO)
	
	return temp_curve


func _on_path_follow_2d_animation_ended(_puck_weight : int) -> void:
	#print("ANIMATION ENDED!")
	table.applyImpulseToTable(_puck_weight)
	animationCompleted.emit()
	await get_tree().create_timer(0.05).timeout
	animateCommand()
