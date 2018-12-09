extends Area2D


signal victory

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _input_event( viewport, event, shapeidx ):
	if (event is InputEventMouseButton && event.pressed):
		var cards_on_board = get_tree().get_nodes_in_group("Card")
		for card in cards_on_board:
			card.queue_free()
		get_tree().get_root().find_node("TurtleCity", true, false).queue_free()
		get_tree().get_root().find_node("WonderTraditionSlot", true, false).queue_free()
		get_tree().get_root().find_node("GrowthDecaySlot", true, false).queue_free()
		get_tree().get_root().find_node("OrderChaosSlot", true, false).queue_free()
		get_tree().get_root().find_node("deck", true, false).queue_free()
		get_tree().get_root().find_node("Fortell", true, false).queue_free()
		get_tree().get_root().find_node("Deck", true, false).queue_free()
		self.queue_free()
		emit_signal("victory")
