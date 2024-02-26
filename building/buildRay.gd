extends RayCast3D

var point;
var square;
var triangle;
var builds;
var ui;
var debugLabel;
const proximityDistance = 8;

func _ready():
	point = get_tree().get_first_node_in_group("BuildRayPoint")
	builds = get_tree().get_first_node_in_group("BuildContainer")
	ui = get_tree().get_first_node_in_group("UI")
	debugLabel = ui.get_child(1)
	square = load("res://building/square.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var endPoint;
	if is_colliding():
		endPoint = get_collision_point()
	else:
		endPoint = -global_transform.basis.z *  5 + global_position
	point.global_position = endPoint
	point.global_rotation = Vector3(0, global_rotation.y,  0)
	
	var minDistance = proximityDistance;
	var closestBuild;
	
	for build in get_tree().get_nodes_in_group("builds"):
		var distanceToBuild = endPoint.distance_to(build.global_position)
		if distanceToBuild < proximityDistance:
			if distanceToBuild < minDistance:
				closestBuild = build
				minDistance = distanceToBuild
				
	# var canPlace = buildsInProximity == 0;
	var canPlace = true;
	var placePos;
	var closestNode;
	
	if closestBuild:
		debugLabel.text = "true"
		var closestNodeDistance = 100;
		for node in closestBuild.nodes:
			var nodeDistance = node.distance_to(point.global_position)
			if nodeDistance < closestNodeDistance:
				closestNode = node
				closestNodeDistance = nodeDistance
		placePos = closestNode
		point.global_rotation = closestBuild.global_rotation
		point.global_position = closestNode
		if placePos.y > 2.25:
			canPlace = false
	else:
		debugLabel.text = "false"

	if Input.is_action_just_pressed("build"):
		if canPlace == true:
			var newSquare = square.instantiate()
			newSquare.add_to_group("builds")
			newSquare.transform = point.transform
			if closestBuild:
				newSquare.global_position = closestNode
				newSquare.rotation = closestBuild.rotation
			builds.add_child(newSquare)
	elif Input.is_action_just_pressed("delete"):
		if closestBuild:
			closestBuild.queue_free()
