extends Node3D

@onready var MagentaBubble = load("res://Scenes/RightBubbleCursor.tscn")
var collided_object = null
var grabbed_object = null
var grab_position = null
var instance = null
var grab_pressed = false
var audio_playing = false
var saber_on = true
@export var raycast_length = 10.0
var result_name = "null"
var result = null

func _process(delta):
	if grabbed_object:
		if not $"../LeftHand".grabbed_object:
			#make sure that when we regrab the object it 
			#doesn't snap to our controller
			grabbed_object.get_parent().get_parent().global_position.x += global_position.x - grab_position.x
			grabbed_object.get_parent().get_parent().global_position.y += global_position.y - grab_position.y
		
		elif $"../LeftHand".grabbed_object.global_position.y < grabbed_object.global_position.y:
			grabbed_object.get_parent().get_parent().global_position.x += global_position.x - grab_position.x
			grabbed_object.get_parent().get_parent().global_position.y += global_position.y - grab_position.y
		
		grab_position = global_position


func _physics_process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var origin = global_position
	var dir = global_basis.z * -1
	var end = 0
	if saber_on:
		end = origin + (dir * raycast_length) 
	else:
		end = origin
	
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	result = space_state.intersect_ray(query)
	
	$"LineRendererRight".points[0] = origin
	if result:
		$"LineRendererRight".points[1] = result.position
		result_name = result.collider.name
	else:
		$"LineRendererRight".points[1] = end
		result_name = "null"

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
			$"LatchSound".play()
			$"RightPick/Label3D/RightGripTimer".start()
			$"RightPick/Label3D".grabbed = true
	
	if name == "ax_button":
		if result_name == "StartTutorialButton":
			result.collider.get_parent().get_parent().global_position.x = 0.0
			result.collider.get_parent().get_parent().global_position.y = 0.0
			result.collider.get_parent().get_parent().global_position.z = 0.0
			saber_on = false
			$"../LeftHand".saber_on = false
			$"../../WorldEnvironment/WorldContainer/TutorialLid".visible = false
			result.collider.get_parent().visible = false
			
			#start the tutorial sequence
			$"../TutorialTimer".start()
			$"../LeftHand/LeftPick/Label3D".tutorial = true
			$"RightPick/Label3D".tutorial = true
			$"../LeftHand/LeftPick/Label3D".titlescreen = false
			$"RightPick/Label3D".titlescreen = false
		
		elif result_name == "StartGameButton":
			result.collider.get_parent().get_parent().global_position.x = 0.0
			result.collider.get_parent().get_parent().global_position.y = 9.9
			result.collider.get_parent().get_parent().global_position.z = -20.0
			saber_on = false
			$"../LeftHand".saber_on = false
			$"../../WorldEnvironment/WorldContainer/FinalLid".visible = false
			result.collider.get_parent().visible = false
			
			#start the game sequence
			$"../LeftHand/LeftPick/Label3D/TimeLeft".start()
			$"../LeftHand/LeftPick/Label3D".game = true
			$"RightPick/Label3D".game = true
			$"../LeftHand/LeftPick/Label3D".titlescreen = false
			$"RightPick/Label3D".titlescreen = false
			

func _on_button_released(name: String) -> void:
	if name == "grip_click":
		grab_pressed = false
		if grabbed_object:
			if (not $"../LeftHand".grabbed_object):
				grabbed_object.get_parent().get_parent().global_position.x = 0
				grabbed_object.get_parent().get_parent().global_position.y = 0
				$"RightPick/Label3D".fall = true
			grabbed_object = null
			grab_position = null
			$"RightPick/Label3D".grabbed = false
			
			$"ReleaseSound".play()
			$"ReleaseSound/PlayTimer".start()
			audio_playing = true
		#if we release an object but our cursor is still inside its area
		#then re-instantiate the bubble
		if collided_object:
			instance = MagentaBubble.instantiate()
			collided_object.add_child(instance)
		

func _on_play_timer_timeout() -> void:
	if audio_playing:
		$"ReleaseSound".stop()
		audio_playing = false


func _on_right_grip_timer_timeout() -> void:
	if grabbed_object:
		if (not $"../LeftHand".grabbed_object):
			grabbed_object.get_parent().get_parent().global_position.x = 0
			grabbed_object.get_parent().get_parent().global_position.y = 0
		grabbed_object = null
		grab_position = null
		
		$"ReleaseSound".play(3.5)
		$"ReleaseSound/PlayTimer".start()
		audio_playing = true


func _on_teleport_timer_timeout() -> void:
	if grabbed_object:
		grabbed_object = null
		grab_position = null


func _on_time_left_timeout() -> void:
	if grabbed_object:
		grabbed_object = null
		grab_position = null


func _on_failsafe_timer_timeout() -> void:
	saber_on = true
