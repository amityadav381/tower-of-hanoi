extends Control

@onready var slot1 := $VBoxContainer/GameControls/Slot1
@onready var slot2 := $VBoxContainer/GameControls/Slot2
@onready var slot3 := $VBoxContainer/GameControls/Slot3
@onready var commandTimer := $Timer

#Value of 0 is invalid input
@export var first_input := 0
@export var second_input := 0
@export var inputHandlingState := 0
@export var input_command_index := 0

signal inputCommandPushed(_cmd_index:int)
 
enum inputHandlingState_t
{
	IDLE = 0,
	WAITING_FOR_NEXT_INPUT,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	first_input         = 0
	second_input        = 0
	inputHandlingState  = 0
	input_command_index = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func clearInputs()->void:
	first_input = 0
	second_input = 0

func handleUserInputs(_user_input: int)->void:
	if inputHandlingState == inputHandlingState_t.IDLE:
		first_input        = _user_input
		inputHandlingState = inputHandlingState_t.WAITING_FOR_NEXT_INPUT
		commandTimer.start()
	elif inputHandlingState == inputHandlingState_t.WAITING_FOR_NEXT_INPUT:
		commandTimer.stop()
		if first_input == _user_input:
			inputHandlingState = inputHandlingState_t.IDLE
			clearInputs()
		else: 
			second_input              = _user_input
			inputHandlingState        = inputHandlingState_t.IDLE
			input_command_index      += 1
			var cmd                  := IntermediateInputCommand.new()
			cmd.slot_from             = first_input
			cmd.slot_to               = second_input
			cmd.move_index            = input_command_index
			#push the command to queue
			Global_Consts.intermediateInputCommands.push_back(cmd)
			#emit signal to notify TableAndPuck scene
			#inputCommandPushed.emit()
			print(first_input, second_input)
			clearInputs()

func _on_slot_1_pressed() -> void:
	print("slot1 pressed")
	handleUserInputs(1)


func _on_slot_2_pressed() -> void:
	print("slot2 pressed")
	handleUserInputs(2)


func _on_slot_3_pressed() -> void:
	print("slot3 pressed")
	handleUserInputs(3)


func _on_timer_timeout() -> void:
	print("Waiting too long, input cancelled")
	clearInputs()
