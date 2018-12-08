extends Area2D


var card = load("res://Card.tscn") # will load when the script is instanced

func _ready():

	pass

func _input_event( viewport, event, shapeidx ):
	if (event is InputEventMouseButton && event.pressed):
		print("Clicked")
		var card_instance = card.instance()
		add_child(card_instance)