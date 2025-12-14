extends Node

signal _tree_entered
# Called when the node enters the scene tree for the first time.s
func _ready() -> void:
	GameInitModule.connectToMainGameLoaded()
	_tree_entered.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
