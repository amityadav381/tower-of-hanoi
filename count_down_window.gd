extends Control


@onready var label           := $Label
@onready var tmr             := $CountDown3
@onready var gameState_      := $GameState

@export var COUNT_DOWN_CONST := 3
var count_down_var           := 0
var count_down_frmt_str      := "%d"
var gamestatestring          := "%d/3"

signal count_down_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameInitModule.on_animation_completed()
	GameInitModule.connectToCountDownNode()
	count_down_var = COUNT_DOWN_CONST
	label.text     = count_down_frmt_str % COUNT_DOWN_CONST
	visible        = false

func start_count_down()->void:
	count_down_var = COUNT_DOWN_CONST
	label.text     = count_down_frmt_str % COUNT_DOWN_CONST
	visible        = true
	label.visible  = true
	tmr.start()

func _on_count_down_3_timeout() -> void:
	count_down_var    -= 1
	if count_down_var:
		label.text     = count_down_frmt_str % count_down_var
		tmr.start()
	else:
		label.text     = "GO!"
		await get_tree().create_timer(1).timeout
		label.visible  = false
		display_game_state()
		count_down_over.emit()

func display_game_state()->void:
	gameState_.visible = true
	gameState_.text = gamestatestring % (GameInitModule.gameLevel+1)
