extends Control

@onready var tag  := $VBoxContainer2/VBoxContainer/Tag
@onready var move := $VBoxContainer2/VBoxContainer/Move
@onready var time := $VBoxContainer2/VBoxContainer/Time

@onready var pro_mv          := $VBoxContainer2/Best/Pro/Move
@onready var pro_tm          := $VBoxContainer2/Best/Pro/Time
@onready var best_gold_mv    := $VBoxContainer2/Best/Gold/Move
@onready var best_gold_tm    := $VBoxContainer2/Best/Gold/Time
@onready var best_silver_mv  := $VBoxContainer2/Best/Silver/Move
@onready var best_silver_tm  := $VBoxContainer2/Best/Silver/Time
@onready var best_bronze_mv  := $VBoxContainer2/Best/Bronze/Move
@onready var best_bronze_tm  := $VBoxContainer2/Best/Bronze/Time

#@onready var animation_player := $PopUpAnimation
#@onready var best_player      := $PopUpBest

var time_str := "Your Best Time :%0.2f"
var move_str := "Your Best Moves:%d"

var pro_time_str := "Pro Time :%0.2f"
var pro_move_str := "Pro Moves:%d"

var gold_time_str := "Gold Time :%0.2f"
var gold_move_str := "Gold Moves:%d"

var silver_time_str := "Silver Time :%0.2f"
var silver_move_str := "Silver Moves:%d"

var bronze_time_str := "Bronze Time :%0.2f"
var bronze_move_str := "Bronze Moves:%d"
#func update_score_popup(_time: float, _moves: int)->void:
	#pass
	##label.text     = disp_string % [_moves, _time]

func new_game(_best_move_cnt: int)->void:
	#tag.text     = "New Game"
	tag.visible  = false
	move.visible = false
	time.visible = false
	
	best_scoreboard_update(_best_move_cnt)
	#animation_player.play("pop_in_player")

func played_game(_time: float, _moves: int, _best_move_cnt: int)->void:
	tag.text     = "Your Best"
	move.text    = move_str % _moves
	time.text    = time_str % _time
	move.visible = true
	time.visible = true

	#best_scoreboard_update(_best_move_cnt)
	#animation_player.play("pop_in_player")

func best_scoreboard_update(_best_move_cnt: int)->void:
	
	pro_mv.text         = pro_move_str  % (_best_move_cnt)
	pro_tm.text         = pro_time_str  % (_best_move_cnt/2.00)
		
	best_gold_mv.text   = gold_move_str   % (_best_move_cnt)
	best_gold_tm.text   = gold_time_str   % (_best_move_cnt)
	
	best_silver_mv.text = silver_move_str % (_best_move_cnt*1.5)
	best_silver_tm.text = silver_time_str % (_best_move_cnt*1.5)
	
	best_bronze_mv.text = bronze_move_str % (_best_move_cnt*2)
	best_bronze_tm.text = bronze_time_str % (_best_move_cnt*2)
	#best_player.play("pop_in_best")

#func reset_all()->void:
	#animation_player.play("RESET")
	#best_player.play("RESET")

func _ready() -> void:
	pass
	#var _temp_ := BestScore.new()
	#_temp_.gold_score.moves_req = 0
	#_temp_.gold_score.time_req  = 0.0
	#
	#_temp_.silver_score.moves_req = 0
	#_temp_.silver_score.time_req  = 0.0
	
	#_temp_.bronze_score.moves_req = 12
	#_temp_.bronze_score.time_req  = 23.14
	#
	#played_game(18.77, 21, _temp_)
	#best_player.play("pop_in_best")
	#visible = false
