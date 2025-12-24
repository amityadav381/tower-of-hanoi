class_name SaveGame
extends Resource

@export var threePuckTable: Array[GameStateAndScores]
@export var fourPuckTable:  Array[GameStateAndScores]

func _init() -> void:
	for i in 27:
		threePuckTable.append(GameStateAndScores.new())
	
	for i in 81:
		fourPuckTable.append(GameStateAndScores.new())
	#threePuckTable.resize(27)
	#threePuckTable.fill(GameStateAndScores.new())
	#fourPuckTable.resize(81)
	#fourPuckTable.fill(GameStateAndScores.new())
	
	
