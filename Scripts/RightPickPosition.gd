extends Node3D


func _process(delta):
	if get_parent().grabbed_object:
		global_position = get_parent().grabbed_object.global_position
		global_position.y = get_parent().grabbed_object.global_position.y - 0.2
		global_position.z = get_parent().grabbed_object.global_position.z + 0.2
		global_basis = get_parent().grabbed_object.global_basis
	else:
		position.x = 0.0
		position.y = -0.2
		position.z = 0.1
		global_basis = get_parent().global_basis
