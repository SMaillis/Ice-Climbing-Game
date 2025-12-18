extends Node3D

var cur_height = 0.0
var max_height = 0.0

func _process(delta: float) -> void:
	cur_height = global_position.y * -1.0
	
	if cur_height >= max_height:
		max_height = cur_height
		#print("Score: ", max_height)
			
	


func _on_teleport_timer_timeout() -> void:
	#move the world back to the starting position
	$"FailsafeTimer".start()
	$"StartMenu".visible = true
	print("teleport top")

func _on_failsafe_timer_timeout() -> void:
	global_position.x = 0
	global_position.y = -10.0
	global_position.z = 0
	print("failsafe top")


func _on_time_left_timeout() -> void:
	$"FailsafeTimer".start()
	$"StartMenu".visible = true
