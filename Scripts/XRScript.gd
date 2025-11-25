extends Node3D

var xr_interface: XRInterface
signal pose_recentered

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
		xr_interface.pose_recentered.connect(_on_openxr_pose_recentered)

	else:
		print("OpenXR not initialized, please check if your headset is connected")

func _on_openxr_pose_recentered():
	emit_signal("pose_recentered")
	XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, true)
