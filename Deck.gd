extends Area2D

var pickupSound = load("res://audio/pickup.wav")

var card = load("res://Card.tscn") # will load when the script is instanced
var can_draw = true

func _ready():

	pass

func reprime_draw():
	self.can_draw = true

func _input_event( viewport, event, shapeidx ):
	if (event is InputEventMouseButton && event.pressed):
		if can_draw:
			# Check how many cards are on the board. If there are exactly three, then that means the day is complete.
			# Ideally we want to add a cool animation between days.
			# For now clear the board, and tell the GameState (which is the root node) to increment the day by 1.
			var cards_on_board = get_tree().get_nodes_in_group("Card")
			if cards_on_board.size() == 3:
				for card in cards_on_board:
					card.queue_free()
				# There is no reason why this should be a get_tree.get_root over a signal, other than that I am 
				# used to using get_tree.get_root.find_node for everything.
				get_tree().get_root().find_node("Board", true, false).end_day()

			else:
				var card_instance = card.instance()
				add_child(card_instance)
				get_node("/root/Board/pickupPlayer").play(0) #play the sound!
				can_draw = false
