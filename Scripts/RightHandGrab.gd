extends Node3D

@onready var MagentaBubble = load("res://Scenes/RightBubbleCursor.tscn")
var collided_object = null
var grabbed_object = null
var grab_position = null
var instance = null
var grab_pressed = false

func _process(delta):
	if grabbed_object:
		if not $"../LeftHand".grabbed_object:
			#make sure that when we regrab the object it 
			#doesn't snap to our controller
			grabbed_object.get_parent().get_parent().global_position.x += global_position.x - grab_position.x
			grabbed_object.get_parent().get_parent().global_position.y += global_position.y - grab_position.y
		
		elif $"../LeftHand".grabbed_object.global_position.y < grabbed_object.global_position.y:
			if not $"../LeftHand".global_position.y - $"../LeftHand".grab_position.y > 0:
				#if left hand is above and pulling down to go up mountain then prioritize it
				#also make sure the right hand isn't trying to go down more than left is up
				grabbed_object.get_parent().get_parent().global_position.x += global_position.x - grab_position.x
				grabbed_object.get_parent().get_parent().global_position.y += global_position.y - grab_position.y
		else:
			#if left is trying to go down more than right is up then go down
			if (abs($"../LeftHand".global_position.y - $"../LeftHand".grab_position.y) < 
				abs(global_position.y - grab_position.y)):
				grabbed_object.get_parent().get_parent().global_position.x += global_position.x - grab_position.x
				grabbed_object.get_parent().get_parent().global_position.y += global_position.y - grab_position.y
		
		grab_position = global_position
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	if collided_object == null:
		#make sure that when we grab an object we can't spawn a bubble
		#by exiting and re-entering its area
		if not grabbed_object and grab_pressed == false:
			instance = MagentaBubble.instantiate()
			body.add_child(instance)
		collided_object = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	#if the bubble is instantiated and we leave a body get rid of it
	if body.get_node("RightBubbleCursor"):
		body.get_node("RightBubbleCursor").queue_free()
		instance = null
	collided_object = null


func _on_button_pressed(name: String) -> void:
	if name == "grip_click":
		grab_pressed = true
		if collided_object:
			#when we grab the object get rid of the bubble
			if collided_object.get_node("RightBubbleCursor"):
				collided_object.get_node("RightBubbleCursor").queue_free()
				instance = null
			grabbed_object = collided_object
			grab_position = global_position

func _on_button_released(name: String) -> void:
	if name == "grip_click":
		grab_pressed = false
		if grabbed_object:
			if (not $"../LeftHand".grabbed_object):
				grabbed_object.get_parent().get_parent().global_position.x = 0
				grabbed_object.get_parent().get_parent().global_position.y = 0
			grabbed_object = null
			grab_position = null
		#if we release an object but our cursor is still inside its area
		#then re-instantiate the bubble
		if collided_object:
			instance = MagentaBubble.instantiate()
			collided_object.add_child(instance)
		
