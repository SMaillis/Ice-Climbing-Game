extends Node3D

var cur_height = 0.0
var max_height = 0.0

func _process(delta: float) -> void:
	cur_height = global_position.y * -1.0
	
	if cur_height >= max_height:
		max_height = cur_height
		print("Score: ", max_height)
			
	
