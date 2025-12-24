class_name GameStateAndScores
extends Resource

@export var gameStatePersist  : Array
@export var targetSlotPersist : int
@export var bestTimeTaken     : float
@export var bestMoveCount     : int

func _init() -> void:
	#print("I got initialized!")
	gameStatePersist   = []
	targetSlotPersist  = 10
	bestTimeTaken      = 10000
	bestMoveCount      = 10000
