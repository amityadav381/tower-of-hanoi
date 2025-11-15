extends Node

@onready var path := $Path2D
@onready var pathFollow2D := $Path2D/PathFollow2D
@onready var remoteTransform := $Path2D/PathFollow2D/RemoteTransform2D
@onready var puck1 := $Puck1
@onready var puck2 := $Puck2
@onready var puck3 := $Puck3
@onready var table := $Table
#Markers for all possible PUCK locations

#region New Code Region
@onready var mrkr_11 := $Table/M11
@onready var mrkr_12 := $Table/M12
@onready var mrkr_13 := $Table/M13

@onready var mrkr_21 := $Table/M21
@onready var mrkr_22 := $Table/M22
@onready var mrkr_23 := $Table/M23

@onready var mrkr_31 := $Table/M31
@onready var mrkr_32 := $Table/M32
@onready var mrkr_33 := $Table/M33
#endregion


@export var inputCommands : Array[InputCommand]

#	1	1	1
#	2	2	2
#	1	2	3
func createCommandForTest()->void:
	var cmd  := InputCommand.new()
	#CMD0
	cmd.puck_position_from = mrkr_11.position
	cmd.puck_position_to   = mrkr_23.position
	cmd.puck_id            = puck1
	cmd.move_index         = 1
	inputCommands.push_back(cmd)

	
	var cmd1  := InputCommand.new()
	#CMD1
	cmd1.puck_position_from = mrkr_12.position
	cmd1.puck_position_to   = mrkr_33.position
	cmd1.puck_id            = puck2
	cmd1.move_index         = 2
	inputCommands.push_back(cmd1)

	
	var cmd2  := InputCommand.new()
	#CMD3
	cmd2.puck_position_from = mrkr_23.position
	cmd2.puck_position_to   = mrkr_12.position
	cmd2.puck_id            = puck1
	cmd2.move_index         = 3
	inputCommands.push_back(cmd2)
	
	var cmd3  := InputCommand.new()
	#CMD3
	cmd3.puck_position_from = mrkr_33.position
	cmd3.puck_position_to   = mrkr_11.position
	cmd3.puck_id            = puck2
	cmd3.move_index         = 4
	inputCommands.push_back(cmd3)

	#print("CMDS0=",inputCommands[0])
	#print("CMDS1=",inputCommands[1])
	#print("CMDS2=",inputCommands[2])
	


func extractCommandFromCommandArray()->InputCommand:
	if not inputCommands.is_empty():
		return inputCommands.pop_front()
	else:
		return null

func _ready() -> void:
	createCommandForTest()
	var _input_command = extractCommandFromCommandArray()
	if _input_command != null:
		pathFollow2D.puck_ref = _input_command.puck_id
		remoteTransform.remote_path = _input_command.puck_id.get_path()
		path.curve = createParabolaCurve(_input_command.puck_position_from,\
		_input_command.puck_position_to)
		pathFollow2D.progress_ratio = 0
		await get_tree().create_timer(1.5).timeout
		pathFollow2D.startFollowing()

func createParabolaCurve(_from_mrkr:Vector2, _to_mrkr:Vector2)-> Curve2D:
	var temp_curve = Curve2D.new()
	print("\ncurv:_from_mrkr", _from_mrkr)
	print("curv:_to_mrkr", _to_mrkr)
	temp_curve.add_point(_from_mrkr, Vector2.ZERO, Vector2(0,-50))
	temp_curve.add_point(_to_mrkr, Vector2(0,-100), Vector2.ZERO)
	
	return temp_curve


func _on_path_follow_2d_animation_ended() -> void:
	table.applyImpulseToTable()
	await get_tree().create_timer(1.5).timeout
	var _input_command = extractCommandFromCommandArray()
	if _input_command != null:
		pathFollow2D.puck_ref = _input_command.puck_id
		pathFollow2D.progress_ratio = 0
		remoteTransform.remote_path = _input_command.puck_id.get_path()
		path.curve = createParabolaCurve(_input_command.puck_position_from,\
		_input_command.puck_position_to)
		#await get_tree().create_timer(2.0).timeout
		pathFollow2D.startFollowing()
