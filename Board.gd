extends Node2D

var day_count = 0;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func end_day():
	day_count = day_count + 1;
	# Build a few new layers at the end of the day.
	for i in range(0, 6):
		get_tree().get_root().find_node("TurtleCity", true, false).generate_new_layer()