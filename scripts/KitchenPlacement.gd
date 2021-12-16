extends Area

export (String) var target_name
export (PackedScene) var kitchen
signal action_done
var is_entered = false

func _on_KitchenPlacement_body_entered(body):
	if not is_entered:
		if body.name == target_name:
			is_entered = true
			var kitch = kitchen.instance()
			kitch.rotation_degrees = Vector3(0,-90,0)
			kitch.translation = Vector3(1,5,0)
			get_parent().add_child(kitch)
			emit_signal("action_done")
		
