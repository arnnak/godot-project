extends Spatial

export var initialize_vr = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if initialize_vr:
		$FPSController.initialise()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
