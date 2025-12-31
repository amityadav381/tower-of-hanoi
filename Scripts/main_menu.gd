extends Control

@export_file("*.tscn") var game_scene

@onready var leader_board := $LocalLeaderboard
var pro_game_count :int = 0
func _ready() -> void:
	#print("ready called from MainMenu cur_lvl = ", cur_lvl)
	leader_board.reset_welcome_text()
	for i in 3:
		#print("MINI BOARD UPDATING")
		await get_tree().create_timer(1).timeout
		leader_board.update_leader_board(i,GameInitModule.save_game.gameLevelRankArray[i])
		if GameInitModule.save_game.gameLevelRankArray[i] == "Pro!":
			pro_game_count += 1
	if pro_game_count == 3:
		leader_board.winning_title_text()
		await get_tree().create_timer(5).timeout
		leader_board.reset_welcome_text()
	pro_game_count = 0


func _on_settings_button_up() -> void:
	pass # Replace with function body.


func _on_start_game_button_up() -> void:
	#print("ENTER THE GAME") # Replace with function body.
	GameInitModule.save_game.currentGameLevel = 0
	GameInitModule.save_game.gameLevelRankArray = ["No Rank","No Rank","No Rank"]
	GameInitModule.gameLevel = GameInitModule.GameLevels.GAME_3PUCK
	GameInitModule.PUCK_COUNT_1INDEXD = 3
	GameInitModule.write_savegame()
	get_tree().change_scene_to_file(game_scene)


func _on_resume_button_up() -> void:
	#if GameInitModule.save_game.currentGameLevel == GameInitModule.GameLevels.GAME_3PUCK:
		#GameInitModule.PUCK_COUNT_1INDEXD = 3
		#get_tree().change_scene_to_file(game_scene)
	if GameInitModule.save_game.currentGameLevel == GameInitModule.GameLevels.GAME_5PUCK:
		GameInitModule.PUCK_COUNT_1INDEXD = 5
		get_tree().change_scene_to_file(game_scene)
	elif GameInitModule.save_game.currentGameLevel == GameInitModule.GameLevels.GAME_7PUCK:
		GameInitModule.PUCK_COUNT_1INDEXD = 7
		get_tree().change_scene_to_file(game_scene)
	elif GameInitModule.save_game.currentGameLevel == GameInitModule.GameLevels.GAME_OVER:
		print("\n\n\n\n\n\n\nGame over")


func _on_quit_button_up() -> void:
	get_tree().quit()
