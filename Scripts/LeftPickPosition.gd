extends Node3D


func _process(delta):
	if get_parent().grabbed_object:
		global_position = get_parent().grabbed_object.global_position
		global_position.z = get_parent().grabbed_object.global_position.z + 0.05
	else:
		global_position = get_parent().global_position
