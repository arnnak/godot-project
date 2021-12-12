extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_teleporting = false

export (PackedScene) var point_visualizer
export (PackedScene) var location_visualizer

export var max_arc_iterations = 32
export var arc_step = 0.1
export var initial_arc_force = 2.25
export var arc_gravity_scale = 1.0

var visualizers = Array();
var location_visualizer_inst

var teleport_location

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(max_arc_iterations):
		var point = point_visualizer.instance()
		add_child(point)
		point.visible = false;
		visualizers.append(point)
	
		location_visualizer_inst = location_visualizer.instance()
		add_child(location_visualizer_inst)
		location_visualizer_inst.visible = false

func _physics_process(delta):
	if is_teleporting:
		var space_state = get_world().direct_space_state
		var start = global_transform.origin
		var end = start
		
		var collided = false;
		
		hide_teleportation_arc()
		
		for i in range(max_arc_iterations):
			var sim_time = i * arc_step
			end = global_transform.origin - global_transform.basis.z * initial_arc_force * sim_time + Vector3.DOWN * sim_time * sim_time * arc_gravity_scale
			var result = space_state.intersect_ray(start, end)
			var point = visualizers[i]
			point.visible = !collided
			if result:
				point.global_transform.origin = result.position
				location_visualizer_inst.global_transform.origin = result.position
				location_visualizer_inst.visible = true
				teleport_location = result.position
				collided = true
				break;
			else:
				point.global_transform.origin = end
			
			start = end
	
func start_teleporting():
	is_teleporting = true
	
func stop_teleporting():
	is_teleporting = false
	hide_teleportation_arc()
	
func hide_teleportation_arc():
	for i in range(max_arc_iterations):
		visualizers[i].visible = false;
	location_visualizer_inst.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
