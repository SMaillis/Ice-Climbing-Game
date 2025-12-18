extends Node3D

var score = 0.0
var cur_height = 0.0
var max_height = 0.0
var game_started = false
var time_left = 0.0
var started = false

func _process(delta: float) -> void:
	cur_height = (global_position.y * -1.0) + 9.9
	if cur_height < 1.0 and not game_started:
		game_started = true
		max_height = cur_height
		$TimeLeft.start()
	
	if game_started:
		if cur_height >= max_height:
			max_height = cur_height
	
	if cur_height > 18.5 and game_started:
		if started == false:
			$"FailsafeTimer".start()
			started = true
		time_left = $TimeLeft.time_left
		score = 20.0
		

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
	game_started = false
	$"TutorialLid".visible = true
	$"FinalLid".visible = true
	$"StartMenu".visible = true
	started = false


func _on_time_left_timeout() -> void:
	$"FailsafeTimer".start()
	$"StartMenu".visible = true
	game_started = false
	score = max_height
	
