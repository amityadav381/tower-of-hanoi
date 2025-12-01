extends Node

@export var my_array : Array[Array]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Array size = ", my_array.size())
	my_array.push_back([2,1,0])
	my_array.push_back([])
	my_array.push_back([])
	#my_array.push_back(13)
	#my_array.push_back(14)
	print("Array = ", my_array)
	print("Array size = ", my_array.size())
	print("Inner Array size = ", my_array.front().size())
	#print(my_array)
	print("Pop front element = ", my_array.pop_back())
	print("Array size = ", my_array.size())
	print("Peep front element = ", my_array.back())
	print("Inner Array size = ", my_array.front().size())
	#print("Array size after peeking = ", my_array.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
