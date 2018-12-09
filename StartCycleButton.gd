extends Area2D

signal start_growth

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _input_event( viewport, event, shapeidx ):
	if (event is InputEventMouseButton && event.pressed):
		var cards_on_board = get_tree().get_nodes_in_group("Card")
		if cards_on_board.size() == 3:
			# There is no reason why this should be a get_tree.get_root over a signal, other than that I am 
			# used to using get_tree.get_root.find_node for everything.
			
			# Hey, it's a signal now, how about that?

			$FortellHighlight.hide()
			emit_signal("start_growth")
