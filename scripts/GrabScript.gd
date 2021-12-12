extends Area

var grabbable_objects : Array
var grabbed_object : RigidBody

func attempt_grab():
	if grabbable_objects.size() == 0:
		return
	
	var min_dist = 9999.99
	var potential_obj = null
	
	for obj in grabbable_objects:
		var dist = global_transform.origin.distance_to(obj.global_transform.origin)
		if dist < min_dist:
			min_dist = dist
			potential_obj = obj
	
	var old_transform = potential_obj.global_transform
	potential_obj.get_parent().remove_child(potential_obj)
	add_child(potential_obj)
	grabbed_object = potential_obj
	grabbed_object.global_transform = old_transform
	grabbed_object.mode = RigidBody.MODE_KINEMATIC

func attempt_release():
	if grabbed_object == null:
		return
	
	if grabbed_object.get_parent() == self:
		var old_transform = grabbed_object.global_transform
		remove_child(grabbed_object)
		get_tree().current_scene.add_child(grabbed_object)
		grabbed_object.global_transform = old_transform
		grabbed_object.mode = RigidBody.MODE_RIGID
		
	grabbed_object = null

func is_grabbing():
	return grabbed_object != null

func _on_HandOverlap_body_entered(body):
	if body is RigidBody:
		grabbable_objects.append(body)


func _on_HandOverlap_body_exited(body):
	if grabbable_objects.find(body) != -1:
		grabbable_objects.erase(body)

