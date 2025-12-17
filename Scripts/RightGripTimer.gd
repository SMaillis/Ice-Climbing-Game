extends Label3D


func _process(delta: float) -> void:
	global_basis = Basis()
	if get_parent().get_parent().grabbed_object:
		text = "Grip Time: %.1f" % $RightGripTimer.time_left
	else:
		text = ""
