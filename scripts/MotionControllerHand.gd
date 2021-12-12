extends ARVRController

signal activated
signal deactivated

enum Handiness {LEFT_HAND, RIGHT_HAND}

export (Handiness) var handiness = Handiness.LEFT_HAND

var check_hand_activation = false

func _ready():
	if handiness == Handiness.LEFT_HAND:
		controller_id = 1
		$RightHand.visible = false
	else:
		controller_id = 2
		$LeftHand.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if check_hand_activation:
		if get_is_active():
			if !visible:
				visible = true
				print("Activated " + name)
				emit_signal("activated")
		elif visible:
			visible = false
			$TeleportationArc.stop_teleporting()
			print("Deactivated " + name)
			emit_signal("deactivated")

func activate_teleporter():
	$TeleportationArc.start_teleporting()
	
func deactivate_teleporter():
	$TeleportationArc.stop_teleporting()

func execute_teleport():
	if $TeleportationArc.is_teleporting:
		get_parent().teleport_to($TeleportationArc.teleport_location)
	$TeleportationArc.stop_teleporting()
	
func get_hand_overlap():
	return $HandOverlap
