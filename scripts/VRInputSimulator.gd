extends Node

var array : Array

export var enabled = false

var controlling_left_hand = false
var controlling_right_hand = false
var controlling_camera = false

var move = false
var move_depth = false
var rotate_pitch = false
var rotate_yaw = false
var rotate_roll = false

export var move_sensitivity = 0.1
export (NodePath) var camera_path
export (NodePath) var left_hand_path
export (NodePath) var right_hand_path

var input_vector : Vector2

var camera : Spatial
var left_hand : Spatial
var right_hand : Spatial

var initial_camera_offset : Vector3
var left_hand_offset_from_camera : Vector3
var right_hand_offset_from_camera : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node(camera_path)
	left_hand = get_node(left_hand_path)
	right_hand = get_node(right_hand_path)
	
	initial_camera_offset = camera.translation
	left_hand_offset_from_camera = left_hand.translation - camera.translation
	right_hand_offset_from_camera = right_hand.translation - camera.translation

func _process(delta):
	if enabled:
		var input = consume_input()
		try_move_left_hand(input, delta)
		try_rotate_left_hand(input, delta)
		try_move_right_hand(input, delta)
		try_rotate_right_hand(input, delta)
		try_move_camera(input, delta)
		try_rotate_camera(input, delta)
		

func _input(event):
	if enabled:
		if event is InputEventKey:
			if event.is_pressed():
				toggle_control_state(event.scancode)
		elif event is InputEventMouseMotion:
			set_input_vector(event.relative)

func toggle_control_state(scancode):
	if scancode == KEY_Q:
		controlling_left_hand = !controlling_left_hand
	elif scancode == KEY_E:
		controlling_right_hand = !controlling_right_hand
	elif scancode == KEY_C:
		controlling_camera = !controlling_camera
	elif scancode == KEY_R:
		reset()
	elif scancode == KEY_T:
		teleport_left()
	elif scancode == KEY_Y:
		teleport_right()
	elif scancode == KEY_U:
		grab_left_hand()
	elif scancode == KEY_I:
		grab_right_hand()
	else:
		move = (!move and scancode == KEY_M)
		move_depth = (!move_depth and scancode == KEY_N)
		rotate_pitch = (!rotate_pitch and scancode == KEY_A)
		rotate_yaw = (!rotate_yaw and scancode == KEY_S)
		rotate_roll = (!rotate_roll and scancode == KEY_D)

func set_input_vector(relative):
	input_vector = relative

func consume_input():
	var result = Vector2(input_vector)
	input_vector = Vector2.ZERO
	return result

func try_move_left_hand(amount,delta):
	move_node(controlling_left_hand, left_hand, amount, delta, !move_depth)
	
func try_move_right_hand(amount,delta):
	move_node(controlling_right_hand, right_hand, amount, delta, !move_depth)
	
func try_move_camera(amount,delta):
	move_node(controlling_camera, camera, amount, delta, !move_depth)

func move_node(should_move : bool, node: Spatial, amount : Vector2, delta : float, move_on_plane = true):
	if should_move and (move or !move_on_plane):
		var delta_offset : Vector3
		if move_on_plane:
			delta_offset = Vector3(amount.x, -amount.y, 0) * delta * move_sensitivity
		else:
			delta_offset = Vector3(0, 0, amount.y) * delta * move_sensitivity
		node.translate_object_local(delta_offset)

func try_rotate_left_hand(amount,delta):
	rotate_hand(controlling_left_hand, left_hand, amount.x, delta)
	
func try_rotate_right_hand(amount,delta):
	rotate_hand(controlling_right_hand, right_hand, amount.x, delta)
	
func try_rotate_camera(amount,delta):
	rotate_hand(controlling_camera, camera, amount.x, delta)
	
func rotate_hand(should_rotate: bool, node: Spatial, amount: float, delta : float):
	if should_rotate:
		var axis = Vector3.ZERO
		if rotate_pitch:
			axis = Vector3.RIGHT
		elif rotate_yaw:
			axis = Vector3.UP
		elif rotate_roll:
			axis = Vector3.FORWARD
		if axis != Vector3.ZERO:
			node.rotate_object_local(axis, amount*delta*move_sensitivity)

func reset():
	camera.translation = initial_camera_offset
	camera.rotation = Vector3.ZERO
	left_hand.translation = initial_camera_offset + left_hand_offset_from_camera
	left_hand.rotation = Vector3.ZERO
	right_hand.translation = initial_camera_offset + right_hand_offset_from_camera
	right_hand.rotation = Vector3.ZERO

func teleport_left():
	var teleporter = get_node("../Teleporter")
	if left_hand.get_node("TeleportationArc").is_teleporting:
		left_hand.execute_teleport()
	else:
		teleporter.activate_left_teleporter()
	
func teleport_right():
	var teleporter = get_node("../Teleporter")
	if right_hand.get_node("TeleportationArc").is_teleporting:
		right_hand.execute_teleport()
	else:
		teleporter.activate_right_teleporter()
		
func grab_left_hand():
	if left_hand.get_hand_overlap().is_grabbing():
		left_hand.get_hand_overlap().attempt_release()
	else:
		left_hand.get_hand_overlap().attempt_grab()
	
	
func grab_right_hand():
	if right_hand.get_hand_overlap().is_grabbing():
		right_hand.get_hand_overlap().attempt_release()
	else:
		right_hand.get_hand_overlap().attempt_grab()
