extends Control

@export_file("*.tscn") var game_scene

@onready var leader_board := $LocalLeaderboard

func _ready() -> void:
	var cur_lvl := GameInitModule.save_game.currentGameLevel
	#print("ready called from MainMenu cur_lvl = ", cur_lvl)
	if cur_lvl == 0:
		for j in 3:
			leader_board.update_leader_board(j,"No Rank")
	else:
		for i in (cur_lvl+1):
			#print("MINI BOARD UPDATING")
			await get_tree().create_timer(1).timeout
			leader_board.update_leader_board(i,GameInitModule.save_game.gameLevelRankArray[i])


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
