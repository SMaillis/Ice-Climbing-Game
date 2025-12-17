extends Label3D

var minutes = 3
var seconds = 0

func _process(delta: float) -> void:
	minutes = int($"TimeLeft".time_left / 60)
	seconds = int($"TimeLeft".time_left - (60*minutes))
	global_basis = Basis()
	
	if get_parent().get_parent().grabbed_object:
		text = "Grip Time: %.1f" % $LeftGripTimer.time_left
	else:
		if seconds >= 10:
			text = "Time Left: " + str(minutes) + ":" + str(seconds)
		else:
			text = "Time Left: " + str(minutes) + ":0" + str(seconds)
		
