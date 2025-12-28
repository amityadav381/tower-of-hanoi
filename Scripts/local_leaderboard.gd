extends Control

@onready var gmae1 := $LeaderBoards/MiniBoard/box1/Game1
@onready var gmae2 := $LeaderBoards/MiniBoard/box2/Game2
@onready var gmae3 := $LeaderBoards/MiniBoard/box3/Game3

#@onready var meme_img := $LeaderBoards/VBoxContainer/Meme

var pro_meme    :Array = \
[
	
]
var gold_meme   :Array = \
[
	
]
var silver_meme :Array = \
[
	
]
var bronze_meme :Array = \
[
	"res://Assets/bronze_meme/p1.png"
]

var game1_stylbox          :StyleBox
var game2_stylbox          :StyleBox
var game3_stylbox          :StyleBox
var lvl_array :Array
var stylbox_array :Array

var color_gold   := Color.GOLD
var color_silver := Color.SILVER
var color_bronze := Color.SADDLE_BROWN
var color_pro    := Color.html("#715ABC")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game1_stylbox = gmae1.get_theme_stylebox("normal").duplicate()
	game2_stylbox = gmae1.get_theme_stylebox("normal").duplicate()
	game3_stylbox = gmae1.get_theme_stylebox("normal").duplicate()
	#reset_all()
	lvl_array = [gmae1, gmae2, gmae3]
	stylbox_array = [game1_stylbox, game2_stylbox, game3_stylbox]

func reset_all():
	gmae1.text = "No Rank"
	gmae2.text = "No Rank"
	gmae3.text = "No Rank"

func update_leader_board(lvl_idx_ :int, rank_:String)->void:
	print("update_leader_board = ",lvl_idx_, rank_)
	lvl_array[lvl_idx_].text = rank_
	if rank_ == "Pro!":
		stylbox_array[lvl_idx_].bg_color = color_pro
	elif rank_ == "Gold":
		print("GOLD COLOR ASSIGNED")
		stylbox_array[lvl_idx_].bg_color = color_gold
	elif rank_ == "Silver":
		stylbox_array[lvl_idx_].bg_color = color_silver
	elif rank_ == "Bronze":
		stylbox_array[lvl_idx_].bg_color = color_bronze
	else:
		lvl_array[lvl_idx_].text = "No Rank"
		
	#print("Color assignment not working")
	lvl_array[lvl_idx_].add_theme_stylebox_override("normal", stylbox_array[lvl_idx_])
	var _new_texture = load(bronze_meme[0])
	#meme_img.texture = _new_texture
