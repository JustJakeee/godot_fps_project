extends StaticBody3D

var nodes = [Vector3(2,0,0),
			 Vector3(-2,0,0),
			 Vector3(0,0,2),
			 Vector3(0,0,-2)];
			

func _ready():
	# Align Nodes with build
	nodes = nodes.map(func(x): return x.rotated(Vector3.UP, rotation.y) + global_position)
	check_nodes()
	
func check_nodes():
	var space_state = get_world_3d().direct_space_state
	for node in nodes:
		var parameters = PhysicsPointQueryParameters3D.new()
		parameters.position = node
		if space_state.intersect_point(parameters).size() > 0:
			nodes.erase(node)
