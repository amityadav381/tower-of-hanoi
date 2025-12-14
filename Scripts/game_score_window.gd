extends Control

@onready var restart_button   := $VBoxContainer/HBoxContainer/RestartButton
@onready var next_game_button := $VBoxContainer/HBoxContainer/NextGame

@onready var mov_cnt_label    := $VBoxContainer/HBoxContainer2/VBoxContainer/MoveCnt
@onready var time_taken_label := $VBoxContainer/HBoxContainer2/VBoxContainer2/TimeTaken

var mv_cnt_frmt_lbl   := "%d"
var time_tkn_frmt_lbl := "%0.2f"

signal gameRestartReq
signal nextGameRreq

func update_score_board(_time: float, _moves: int)->void:
	mov_cnt_label.text     = mv_cnt_frmt_lbl % _moves
	time_taken_label.text  = time_tkn_frmt_lbl % _time



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#update_score_board(13.223, 18)
	visible = false
	GameInitModule.connectRestartRequested()
	GameInitModule.connectNextGameRequested()


func _on_restart_button_button_up() -> void:
	visible = false
	gameRestartReq.emit()


func _on_next_game_button_up() -> void:
	visible = false
	nextGameRreq.emit()
