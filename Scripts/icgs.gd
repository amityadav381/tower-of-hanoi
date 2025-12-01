extends Control

@onready var slot1        := $VBoxContainer/GameControls/Slot1
@onready var slot2        := $VBoxContainer/GameControls/Slot2
@onready var slot3        := $VBoxContainer/GameControls/Slot3
@onready var commandTimer := $Timer
@onready var gSL          := $GameStateLogic

@onready var label        := $VBoxContainer/Navigation/VBoxContainer/Label

@onready var button_a := $VBoxContainer/GameControls/Slot1
@onready var button_b := $VBoxContainer/GameControls/Slot2
@onready var button_c := $VBoxContainer/GameControls/Slot3
var buttonTheme       :Theme    = preload("res://Rough/button_game.tres")
var styleBox          :StyleBox = buttonTheme.get_stylebox("pressed", "Button")
var styleBoxWhite     := styleBox.duplicate(true)
var styleBoxRed       := styleBox.duplicate(true)
var styleBoxGreen     := styleBox.duplicate(true)

#Value of 0 is invalid input
@export var first_input := 0
@export var second_input := 0
@export var inputHandlingState := 0
@export var input_command_index := 0
@export var enable_signal_to_anim_module : bool

signal inputCommandPopulated
 
enum inputHandlingState_t
{
	IDLE = 0,
	WAITING_FOR_NEXT_INPUT,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("../TableAndPuck").animationCompleted.connect(on_animation_completed)
	first_input                  = 0
	second_input                 = 0
	inputHandlingState           = 0
	input_command_index          = 0
	enable_signal_to_anim_module = true
	
	styleBoxWhite.border_color   = Color.WHITE
	styleBoxGreen.border_color   = Color.GREEN
	styleBoxRed.border_color     = Color.RED
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func clearInputs()->void:
	first_input = 0
	second_input = 0

func on_animation_completed()->void:
	enable_signal_to_anim_module = true

func handleUserInputs(_user_input: int)->void:
	if inputHandlingState == inputHandlingState_t.IDLE:
		first_input        = _user_input
		inputHandlingState = inputHandlingState_t.WAITING_FOR_NEXT_INPUT
		commandTimer.start()
	elif inputHandlingState == inputHandlingState_t.WAITING_FOR_NEXT_INPUT:
		commandTimer.stop()
		inputHandlingState = inputHandlingState_t.IDLE
		if first_input == _user_input: 
			resetButtonTheme()
			clearInputs()
		else: 
			second_input              = _user_input
			input_command_index      += 1
			label.text                = str(input_command_index)
			var cmd                  := IntermediateInputCommand.new()
			cmd.slot_from             = first_input
			cmd.slot_to               = second_input
			cmd.move_index            = input_command_index
			#print("\nslot_from = ", cmd.slot_from)
			#print("slot_to = ", cmd.slot_to)
			#print("move_index = ", cmd.move_index)
			#push the command to queue
			var is_cmd_valid :bool = gSL.processIICommand(cmd)
			if is_cmd_valid:
				buttonTheme.set_stylebox("pressed", "Button", styleBoxWhite)
			else:
				buttonTheme.set_stylebox("pressed", "Button", styleBoxRed)
			await get_tree().create_timer(0.05).timeout 
			resetButtonTheme()
			if is_cmd_valid and enable_signal_to_anim_module:
				inputCommandPopulated.emit()
				enable_signal_to_anim_module = false
			#emit signal to notify TableAndPuck scene
			clearInputs()

func resetButtonTheme()->void:
	button_a.button_pressed = false
	button_b.button_pressed = false
	button_c.button_pressed = false
	buttonTheme.set_stylebox("pressed", "Button", styleBox)

func _on_slot_1_pressed() -> void:
	#print("slot0 pressed")
	handleUserInputs(0)


func _on_slot_2_pressed() -> void:
	#print("slot1 pressed")
	handleUserInputs(1)


func _on_slot_3_pressed() -> void:
	#print("slot2 pressed")
	handleUserInputs(2)


func _on_timer_timeout() -> void:
	#print("Waiting too long, input cancelled")
	inputHandlingState = inputHandlingState_t.IDLE
	resetButtonTheme()
	clearInputs()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("slot1"):
		handleUserInputs(0)
	elif event.is_action_pressed("slot2"):
		handleUserInputs(1)
	elif event.is_action_pressed("slot3"):
		handleUserInputs(2)
