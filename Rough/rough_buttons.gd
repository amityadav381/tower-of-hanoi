extends Control

@onready var button_a := $HBoxContainer/Button
@onready var button_b := $HBoxContainer/Button2
@onready var button_c := $HBoxContainer/Button3


var buttonTheme :Theme = preload("res://Rough/button_game.tres")


var styleBox :StyleBox = buttonTheme.get_stylebox("pressed", "Button")
#var styleBoxRed :StyleBox = buttonTheme.get_stylebox("pressed", "Button")
#var styleBoxGreen :StyleBox = buttonTheme.get_stylebox("pressed", "Button")
var styleBoxWhite := styleBox.duplicate(true)
var styleBoxRed   := styleBox.duplicate(true)
var styleBoxGreen := styleBox.duplicate(true)

enum State { RESET, FIRST_PRESSED, SECOND_PRESSED }

func _ready() -> void:
	#print("style_box = ", styl_bx)
	#print("style_box = ", typeof(styl_bx))
	print("button.style_box = ", button_c.get_theme_stylebox("pressed"))
	print("button.style_box = ", button_b.get_theme_stylebox("pressed"))
	print("button.style_box = ", button_a.get_theme_stylebox("pressed"))
	styleBoxWhite.border_color = Color.WHITE
	styleBoxGreen.border_color = Color.GREEN
	styleBoxRed.border_color   = Color.RED
	
	#buttonTheme.set_stylebox("pressed", "Button", styleBoxGreen)
	#buttonTheme.set_stylebox("pressed", "Button", styleBoxRed)
	#buttonTheme.set_stylebox("pressed", "Button", styleBoxWhite)
	

# Variable to track the state
var current_state = State.RESET

func _state(_button:int)->void:
	if current_state == State.RESET:
		current_state = State.FIRST_PRESSED
		button_c.theme.set_stylebox("pressed", "Button", styleBox)
		#button_c.add_theme_stylebox_override("pressed", Color.WEB_MAROON)
		#styleBox = button_c.get_theme_stylebox("pressed")
		#styleBox.border_color = Color.WEB_MAROON
		print("1ST PRESS")
		#border_color
	elif current_state == State.FIRST_PRESSED:
		#button_c.theme.set_stylebox("pressed", "Button", styleBoxGreen)
		#await get_tree().create_timer(0.2).timeout
		#button_c.theme.set_stylebox("pressed", "Button", styleBox)
		#button_c.theme.set_stylebox("pressed", "Button", styleBoxGreen)
		#var tw = Tween.new()
		#_start_blink()
		button_c.theme.set_stylebox("pressed", "Button", styleBoxWhite)
		await get_tree().create_timer(0.2).timeout 
		button_a.button_pressed = false
		button_b.button_pressed = false
		button_c.button_pressed = false
		
		current_state = State.SECOND_PRESSED
		print("2ND PRESS")
	elif current_state == State.SECOND_PRESSED:
		current_state = State.RESET
		

func _on_button_pressed() -> void:
	_state(1)


func _on_button_2_pressed() -> void:
	_state(2)


func _on_button_3_pressed() -> void:
	_state(3)
	
func _start_blink():
	var color_a = Color(0.07, 0.77, 0.769, 1.0)
	var color_b = Color(1,0.2,0.2)
	var t := create_tween()
	t.set_loops(3)                   # loop infinitely
	t.tween_property(styleBox, "border_color", color_b, 0.2)
	t.tween_property(styleBox, "border_color", color_a, 0.2)
