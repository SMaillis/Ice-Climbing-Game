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
			text = "You can stay latched for 10 seconds"
		elif fall:
			text = "So always make sure to keep one pick on the wall"
		else:
			text = "Press the side grip buttons to grab the wall"
	
	elif game:
		pass
		
	elif titlescreen:
		text = ""
	

func _on_tutorial_timer_timeout() -> void:
	tutorial = false
	text = "Have Fun!"
	print("tutorial right")
	


func _on_failsafe_timer_timeout() -> void:
	titlescreen = true
	print("failsafe right")


func _on_time_left_timeout() -> void:
	game = false
