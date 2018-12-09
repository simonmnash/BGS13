extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var clouds = load("res://Clouds.tscn")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var cloud = clouds.instance()
	add_child(cloud)
	pass

func _input_event( viewport, event, shapeidx ):
	if (event is InputEventMouseButton && event.pressed):
		get_tree().change_scene("res://Board.tscn")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
