extends Node

export (NodePath) var kitchen_location


func _on_KitchenPlacement_action_done():
	get_node(kitchen_location).monitoring = false
	get_node(kitchen_location).visible = false
