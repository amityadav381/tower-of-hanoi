extends Node

@export var inputCommands : Array[InputCommand]
@export var intermediateInputCommands :Array[IntermediateInputCommand]

func _ready() -> void:
	print("SINGLETON IS READY")
	inputCommands.clear()
	intermediateInputCommands.clear()
