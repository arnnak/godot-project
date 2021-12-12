extends ARVRController

signal activated
signal deactivated

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_is_active():
		if !visible:
			visible = true
			print("Activated " + name)
			emit_signal("activated")
	elif visible:
		visible = false
		print("Deactivated " + name)
		emit_signal("deactivated")

func _input(event):
	print(event.device)
	if event is InputEventJoypadButton and event.button_index == JOY_VR_PAD and event.device+1 == controller_id:
		if event.is_pressed():
			$TeleportArc.start_teleporting()
		else:
			$TeleportArc.stop_teleporting()
