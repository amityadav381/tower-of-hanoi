extends Node

@onready var path := $Path2D
@onready var pathFollow2D := $Path2D/PathFollow2D
@onready var left_marker  := $Table/M1
@onready var right_marker := $Table/M3

func _ready() -> void:
	pass
	#path.curve = create_parabola_curve()
	#await get_tree().create_timer(5.0).timeout
	#pathFollow2D.start_following()

func create_parabola_curve()-> Curve2D:
	var temp_curve = Curve2D.new()
	print("left_marker.position", left_marker.position)
	print("right_marker.position", right_marker.position)
	temp_curve.add_point(left_marker.position, Vector2.ZERO, Vector2(0,-80)) 
	temp_curve.add_point(right_marker.position\
	, Vector2(0,-200)\
	#, Vector2(0,-(right_marker.position.x - left_marker.position.x))\
	, Vector2.ZERO)
	
	#temp_curve.set_point_position(0, left_marker.position)
	#temp_curve.set_point_position(1, right_marker.position)
	#temp_curve.set_point_out(0, Vector2(50,-50))
	#temp_curve.set_point_in(1, Vector2(-50,-50))
	
	return temp_curve
