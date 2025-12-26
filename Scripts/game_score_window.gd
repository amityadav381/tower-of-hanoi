extends Control

@onready var restart_button   := $VBoxContainer/HBoxContainer/RestartButton
@onready var next_game_button := $VBoxContainer/HBoxContainer/NextGame

@onready var mov_cnt_label    := $VBoxContainer/HBoxContainer2/VBoxContainer/MoveCnt
@onready var time_taken_label := $VBoxContainer/HBoxContainer2/VBoxContainer2/TimeTaken

@onready var rank_label       := $VBoxContainer/Label
@onready var best_score_card  := $BestScorePopUp

@export_file("*.tscn") var main_menu_scene

var mv_cnt_frmt_lbl   := "%d"
var time_tkn_frmt_lbl := "%0.2f"
var panel_stylebox    :StyleBoxFlat

signal gameRestartReq
signal nextGameRreq

func update_score_board(_time: float, player_best_tm:float, \
_moves: int, player_best_mv:int, min_move: int, replaying:bool)->void:
	
	mov_cnt_label.text     = mv_cnt_frmt_lbl % _moves
	time_taken_label.text  = time_tkn_frmt_lbl % _time
	
	#var rank_ := 0 # Pro=0; Gold=1; Silver=2; Bronze=3
	if replaying:
		best_score_card.played_game(player_best_tm, player_best_mv, min_move)
	else:
		best_score_card.new_game(min_move)
	
	
	if _moves <= min_move:
		if _time <= min_move*0.75:
			panel_stylebox.bg_color = Color.html("#715ABC")
			rank_label.text = "PRO!"
			rank_label.add_theme_stylebox_override("normal", panel_stylebox)
		elif _time <= min_move:
			panel_stylebox.bg_color = Color.GOLD
			rank_label.text = "GOLD!"
			rank_label.add_theme_stylebox_override("normal", panel_stylebox)
		else:
			panel_stylebox.bg_color = Color.SILVER
			rank_label.text = "SILVER!"
			rank_label.add_theme_stylebox_override("normal", panel_stylebox)

	elif _moves <= (min_move*1.5) :
		if _time <= (min_move*1.5):
			panel_stylebox.bg_color = Color.SILVER
			rank_label.text = "SILVER!"
			rank_label.add_theme_stylebox_override("normal", panel_stylebox)
		else:
			panel_stylebox.bg_color = Color.SADDLE_BROWN
			rank_label.text = "BRONZE!"
			rank_label.add_theme_stylebox_override("normal", panel_stylebox)
	else:
		panel_stylebox.bg_color = Color.SADDLE_BROWN
		rank_label.text = "BRONZE!"
		rank_label.add_theme_stylebox_override("normal", panel_stylebox)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#update_score_board(13.223, 18)
	visible = false
	panel_stylebox = rank_label.get_theme_stylebox("normal").duplicate()
	GameInitModule.connectRestartRequested()
	GameInitModule.connectNextGameRequested()


func _on_restart_button_button_up() -> void:
	visible = false
	gameRestartReq.emit()


func _on_next_game_button_up() -> void:
	visible = false
	if GameInitModule.PUCK_COUNT_1INDEXD == 7:
		get_tree().change_scene_to_file(main_menu_scene)
	else:
		nextGameRreq.emit()
