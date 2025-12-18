extends Label3D

var game_finished = false
var tutorial = false
var height = 0.0

func _process(delta: float) -> void:
	if game_finished:
		height = get_parent().get_parent().score
		if height > 19:
			height = 20.00
		text = "Height Reached: %.2f" % height
	else:
		text = ""
	
func _on_failsafe_timer_timeout() -> void:
	game_finished = true
