extends Label3D

var minutes = 3
var seconds = 0

var titlescreen = true
var tutorial = false
var game = false
var fall = false
var grabbed = false


func _process(delta: float) -> void:
	global_basis = Basis()
	
	#tutorial text
	if tutorial:
		if grabbed:
			text = "You'll have 3 minutes to reach the top"
		elif fall:
			text = "You’ll fall if both picks are unlatched"
		else:
			text = "Welcome to Summit Scaler"
	
	elif game:
		minutes = int($"TimeLeft".time_left / 60)
		seconds = int($"TimeLeft".time_left - (60*minutes))
	
		if get_parent().get_parent().grabbed_object:
			text = "Grip Time: %.1f" % $LeftGripTimer.time_left
		else:
			if seconds >= 10:
				text = "Time Left: " + str(minutes) + ":" + str(seconds)
			else:
				text = "Time Left: " + str(minutes) + ":0" + str(seconds)
	
	elif titlescreen:
		text = ""
	

func _on_tutorial_timer_timeout() -> void:
	tutorial = false
	fall = false
	text = "Good Luck!"
	$"TeleportTimer".start()
	print("tutorial left")


func _on_failsafe_timer_timeout() -> void:
	titlescreen = true
	tutorial = false
	game = false
	print("failsafe left")


func _on_time_left_timeout() -> void:
	game = false
	
