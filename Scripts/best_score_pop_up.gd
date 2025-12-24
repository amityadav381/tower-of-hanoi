extends Control

@onready var tag  := $VBoxContainer/Tag
@onready var move := $VBoxContainer/Move
@onready var time := $VBoxContainer/Time

@onready var best_gold_mv    := $Best/Gold/Move
@onready var best_gold_tm    := $Best/Gold/Time
@onready var best_silver_mv  := $Best/Silver/Move
@onready var best_silver_tm  := $Best/Silver/Time
@onready var best_bronze_mv  := $Best/Bronze/Move
@onready var best_bronze_tm  := $Best/Bronze/Time

@onready var animation_player := $PopUpAnimation
@onready var best_player      := $PopUpBest



func update_score_popup(_time: float, _moves: int)->void:
	pass
	#label.text     = disp_string % [_moves, _time]

func new_game(_best_score: BestScore)->void:
	tag.text     = "New Game"
	move.visible = false
	time.visible = false
	
	best_scoreboard_update(_best_score)
	animation_player.play("pop_in_player")

func played_game(_time: float, _moves: int, _best_score: BestScore)->void:
	tag.text     = "Your Best"
	move.text    = move.text % _moves
	time.text    = time.text % _time
	move.visible = true
	time.visible = true

	best_scoreboard_update(_best_score)
	animation_player.play("pop_in_player")

func best_scoreboard_update(_best_score: BestScore)->void:
	best_gold_mv.text   = best_gold_mv.text   % _best_score.gold_score.moves_req
	best_gold_tm.text   = best_gold_tm.text   % _best_score.gold_score.time_req
	best_silver_mv.text = best_silver_mv.text % _best_score.silver_score.moves_req
	best_silver_tm.text = best_silver_tm.text % _best_score.silver_score.time_req
	best_bronze_mv.text = best_bronze_mv.text % _best_score.bronze_score.moves_req
	best_bronze_tm.text = best_bronze_tm.text % _best_score.bronze_score.time_req

func reset_all()->void:
	animation_player.play("RESET")

func _ready() -> void:
	var _temp_ := BestScore.new()
	_temp_.gold_score.moves_req = 4
	_temp_.gold_score.time_req  = 3.87
	
	_temp_.silver_score.moves_req = 3
	_temp_.silver_score.time_req  = 1.67
	
	_temp_.bronze_score.moves_req = 12
	_temp_.bronze_score.time_req  = 23.14
	
	played_game(18.77, 21, _temp_)
	best_player.play("pop_in_best")
	#visible = false
