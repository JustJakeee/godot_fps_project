extends RayCast3D

var point;
var square;
var triangle;
var builds;

func _ready():
	point = get_tree().get_first_node_in_group("BuildRayPoint")
	builds = get_tree().get_first_node_in_group("BuildContainer")
	square = load("res://square.tscn")
	triangle = load("res://triangle.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var endPoint;
	if is_colliding():
		endPoint = get_collision_point()
	else:
		endPoint = -global_transform.basis.z *  5 + global_position
	point.global_position = endPoint
	point.global_rotation = Vector3(0, global_rotation.y,  0)
	
	var buildsInProximity = [];
	var minDistance = 4;
	var closestBuild;
	
	for build in get_tree().get_nodes_in_group("builds"):
		var distanceToBuild = endPoint.distance_to(build.global_position)
		if distanceToBuild < 4:
			buildsInProximity.append(build)
			print(distanceToBuild)
			if distanceToBuild < minDistance:
				closestBuild = build
			
	# var canPlace = buildsInProximity == 0;
	var canPlace = true;
	var placePos;
	
	if closestBuild:
		var closestNode;
		var closestNodeDistance = 100;
		for node in closestBuild.nodes:
			var nodeDistance = node.distance_to(endPoint)
			if nodeDistance < closestNodeDistance:
				closestNode = node
				closestNodeDistance = nodeDistance
		placePos = closestNode
		point.global_rotation = closestBuild.global_rotation
		
	if closestBuild:
		point.global_position = closestBuild.global_position + Vector3(0,1,0)

	if Input.is_action_just_pressed("square"):
		print(buildsInProximity)
		if canPlace == true:
			var newSquare = square.instantiate()
			newSquare.transform = point.transform
			if closestBuild:
				newSquare.global_position = placePos
			newSquare.add_to_group("builds")
			builds.add_child(newSquare)
