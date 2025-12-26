extends Control

@export_file("*.tscn") var game_scene


func _on_settings_button_up() -> void:
	pass # Replace with function body.


func _on_start_game_button_up() -> void:
	#print("ENTER THE GAME") # Replace with function body.
	GameInitModule.gameLevel = GameInitModule.GameLevels.GAME_3PUCK
	GameInitModule.PUCK_COUNT_1INDEXD = 3
	get_tree().change_scene_to_file(game_scene)


func _on_resume_button_up() -> void:
	if GameInitModule.gameLevel == GameInitModule.GameLevels.GAME_3PUCK:
		GameInitModule.PUCK_COUNT_1INDEXD = 3
		get_tree().change_scene_to_file(game_scene)
	elif GameInitModule.gameLevel == GameInitModule.GameLevels.GAME_5PUCK:
		GameInitModule.PUCK_COUNT_1INDEXD = 5
		get_tree().change_scene_to_file(game_scene)
	elif GameInitModule.gameLevel == GameInitModule.GameLevels.GAME_7PUCK:
		GameInitModule.PUCK_COUNT_1INDEXD = 7
		get_tree().change_scene_to_file(game_scene)
	elif GameInitModule.gameLevel == GameInitModule.GameLevels.GAME_OVER:
		print("\n\n\n\n\n\n\nGame over")
