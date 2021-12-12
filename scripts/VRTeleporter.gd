extends Node

var controller_states

export var axis_deadzone = 0.75

func _ready():
	controller_states = {
		1: {
			"axes": Vector2(0,0),
			"wants_to_teleport": false,
			"wanted_to_teleport": false
		},
		2: {
			"axes": Vector2(0,0),
			"wants_to_teleport": false,
			"wanted_to_teleport": false
		}
	}

func _input(event):
	if event is InputEventJoypadMotion and (event.axis == JOY_AXIS_0 or event.axis == JOY_AXIS_1):
		var axes = Vector2(Input.get_joy_axis(event.device, JOY_AXIS_0), Input.get_joy_axis(event.device, JOY_AXIS_1))
		if axes.y > axis_deadzone and controller_states[event.device+1].axes.y <= axis_deadzone and not controller_states[event.device+1].wanted_to_teleport:
			controller_states[event.device+1].wants_to_teleport = true
			start_teleport(event.device+1)
		elif controller_states[event.device+1].wants_to_teleport and axes.length() < axis_deadzone:
			controller_states[event.device+1].wants_to_teleport = false
			finish_teleport(event.device+1)
			
		controller_states[event.device+1].wanted_to_teleport = controller_states[event.device+1].wants_to_teleport

func start_teleport(device_id):
	if device_id == 1:
		activate_left_teleporter()
	else:
		activate_right_teleporter()
	
func activate_left_teleporter():
	get_hand(1)	.activate_teleporter()
	get_hand(2).deactivate_teleporter()
	
func activate_right_teleporter():
	get_hand(2)	.activate_teleporter()
	get_hand(1).deactivate_teleporter()

func finish_teleport(device_id):
	get_hand(device_id).execute_teleport()

func get_hand(device_id):
	if device_id == 1:
		return get_node("../LeftHand")
	else:
		return get_node("../RightHand")
