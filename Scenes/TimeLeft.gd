extends Label3D

var minutes = 3
var seconds = 0

func _process(delta: float) -> void:
	minutes = int($"TimeLeft".time_left / 60)
	seconds = int($"TimeLeft".time_left - (60*minutes))
	global_basis = Basis()
	text = "Time Left: " + str(minutes) + ":" + str(seconds)
