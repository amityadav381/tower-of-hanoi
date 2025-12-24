extends Control

@export_file("*.tscn") var game_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	#print("ENTER THE GAME") # Replace with function body.
	GameInitModule.PUCK_COUNT_1INDEXD = 3
	get_tree().change_scene_to_file(game_scene)


func _on_button_2_button_up() -> void:
	GameInitModule.PUCK_COUNT_1INDEXD = 4
	get_tree().change_scene_to_file(game_scene)
