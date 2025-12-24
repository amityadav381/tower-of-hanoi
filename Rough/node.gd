extends Node

#@onready var path_follower := $Path2D/PathFollow2D

#@export var my_array : Array[Array]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(" 4%3 = ", 4%3)
	print(" 3%3 = ", 3%3)
	print(" 2%3 = ", 2%3)
	print(" 1%3 = ", 1%3)
	print(" 0%3 = ", 0%3)
	#print("Array size = ", my_array.size())
	#my_array.push_back([2,1,0])
	#my_array.push_back([])
	#my_array.push_back([])
	#my_array.push_back(13)
	#my_array.push_back(14)
	#print("Array = ", my_array)
	#print("Array size = ", my_array.size())
	#print("Inner Array size = ", my_array.front().size())
	##print(my_array)
	#print("Pop front element = ", my_array.pop_back())
	#print("Array size = ", my_array.size())
	#print("Peep front element = ", my_array.back())
	#print("Inner Array size = ", my_array.front().size())
	#print("Array size after peeking = ", my_array.size())

# Called every frame. 'delta' is the elapsed time since the previous frame

#
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#print("AREA ENTERED IS = ",area)
#
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("BODY ENTERED IS = ",body.name)
	#if body.name == "CharacterBody2D":
		#print("Found a character body 2d")
		#path_follower.start_animating_path()
