extends HBoxContainer

@export_file("*.tscn") var main_menu_scene
@onready var restart_ := $Restart
@onready var pause_   := $Pause

var paused:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_.text     = "P"


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func enable_restart_from_navigation()->void:
	restart_.disabled = false

func disable_restart_from_navigation()->void:
	restart_.disabled = true

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file(main_menu_scene)


func _on_restart_button_up() -> void:
	GameInitModule.on_gameRestart_Navigation()

func enable_pause_button()->void:
	pause_.disabled = false

func disable_pause_button()->void:
	pause_.disabled = true

func _on_pause_button_up() -> void:
	if paused == false:
		pause_.disabled = true
		paused          = true
		pause_.text     = ">"
		GameInitModule.pause_the_timer()
		await get_tree().create_timer(1).timeout
		pause_.disabled = false
	elif paused == true:
		pause_.disabled = true
		paused          = false
		pause_.text     = "P"
		GameInitModule.unpause_the_timer()
		await get_tree().create_timer(1).timeout
		pause_.disabled = false
