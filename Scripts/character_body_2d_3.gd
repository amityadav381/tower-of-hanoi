extends CharacterBody2D

@onready var panel_size := $Panel

#var puckPanelTheme    :Theme    = preload("res://Resources/puck_3_.tres")
var new_stylebox_normal          :StyleBox

# The snippet below assumes the child node "MyButton" has a StyleBoxFlat assigned.
# Resources are shared across instances, so we need to duplicate it
# to avoid modifying the appearance of all other buttons.

#new_stylebox_normal.border_width_top = 3
#var color_array4 :Array[Color] = \
#[ 
	#Color(0.166, 0.232, 0.34, 1.0),
	#Color(0.242, 0.328, 0.468),
	#Color(0.701, 0.753, 0.815),
	#Color(1,1,1)
#]
#var color_array3 :Array[Color] = \
#[
	#Color(0.242, 0.328, 0.468),
	#Color(0.701, 0.753, 0.815),
	#Color(1,1,1)
#]
var color_array7 :Array[Color] = \
[ 
	Color(0x000000ff),
	Color(0x272727ff),
	Color(0x484848ff),
	Color(0x6e6e6eff),
	Color(0x979797ff),
	Color(0xc3c3c3ff),
	Color(0xffffffff)
]

var color_array5 :Array[Color] = \
[ 
	Color(0x484848ff),
	Color(0x6e6e6eff),
	Color(0x979797ff),
	Color(0xc3c3c3ff),
	Color(0xffffffff)
]
var color_array3 :Array[Color] = \
[
	Color(0x979797ff),
	Color(0xc3c3c3ff),
	Color(0xffffffff)
]

func _ready() -> void:
	new_stylebox_normal = panel_size.get_theme_stylebox("panel").duplicate()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
	move_and_slide()

#90 is the max puck size
func set_the_puck_visual_size(_size_id: int)->void:
	var _size :int = 0
	if _size_id == 6:
		_size = 5
	else:
		_size = 90 - 15*(_size_id)
	#print("_size_id = ", _size_id)
	#print("_size = ", _size)
	#print("PUCK SIZE = ",_size)
	var _half_size :float = _size/2.0
	#print("_half_size = ", _half_size)
	#var pwr = 1.5**_size_id
	#var add = 80*_size_id
	if GameInitModule.PUCK_COUNT_1INDEXD == 3:
		new_stylebox_normal.bg_color = color_array3[_size_id]
	elif GameInitModule.PUCK_COUNT_1INDEXD == 5:
		new_stylebox_normal.bg_color = color_array5[_size_id]
	else:
		new_stylebox_normal.bg_color = color_array7[_size_id]
	#new_stylebox_normal.bg_color = Color(172 + add, 188 + add, 208 + add)
	panel_size.add_theme_stylebox_override("panel", new_stylebox_normal)
	panel_size.size.x = _size
	panel_size.position = Vector2(-_half_size, -10)
