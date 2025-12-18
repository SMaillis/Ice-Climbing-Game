extends Label3D

var game_finished = false
var tutorial = false
var time = 0.0

func _process(delta: float) -> void:
	if game_finished:
		time = get_parent().get_parent().time_left
		var minutes = int(time / 60)
		var seconds = int(time - (60*minutes))
		if seconds >= 10:
			text = "Time Left: " + str(minutes) + ":" + str(seconds)
		else:
			text = "Time Left: " + str(minutes) + ":0" + str(seconds)
	else:
		text = ""
	
func _on_failsafe_timer_timeout() -> void:
	game_finished = true
