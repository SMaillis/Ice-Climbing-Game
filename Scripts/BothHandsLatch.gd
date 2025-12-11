extends Node3D

var grabbed_object = null
var left_obj = null
var right_obj = null
var prev_left = null
var prev_right = null
var left_released = true
var right_released = true


func _process(delta):
	left_obj = $LeftHand.grabbed_object
	right_obj = $RightHand.grabbed_object
	if left_obj and right_obj:
		if left_obj.global_position.y == right_obj.global_position.y:
			left_released = false
			right_released = false
			if prev_right and prev_left:
				left_obj.get_parent().get_parent().global_position.x += (($LeftHand.global_position.x - prev_left.x) / 2)
				left_obj.get_parent().get_parent().global_position.x += (($RightHand.global_position.x - prev_right.x) / 2)
				left_obj.get_parent().get_parent().global_position.y += (($LeftHand.global_position.y - prev_left.y) / 2)
				left_obj.get_parent().get_parent().global_position.y += (($RightHand.global_position.y - prev_right.y) / 2)
		
		prev_left = $LeftHand.global_position
		prev_right = $RightHand.global_position
		
	else:
		prev_left = null
		prev_right = null
	


func _on_left_hand_button_released(name: String) -> void:
	if name == "grip_click":
		left_released = true
		if grabbed_object:
			if left_released and right_released:
				grabbed_object = null
			


func _on_right_hand_button_released(name: String) -> void:
	if name == "grip_click":
		right_released = true
		if grabbed_object:
			if left_released and right_released:
				grabbed_object = null
