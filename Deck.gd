extends Area2D

var pickupSound = load("res://audio/pickup.wav")

var card = load("res://Card.tscn") # will load when the script is instanced
var can_draw = true
func _ready():
	pass

func reprime_draw():
	self.can_draw = true
	var cards_on_board = get_tree().get_nodes_in_group("Card")
	if cards_on_board.size() == 0:
		$Highlight.show()

func _input_event( viewport, event, shapeidx ):
	if (event is InputEventMouseButton && event.pressed):
		if can_draw:
			$Highlight.hide()
			var cards_on_board = get_tree().get_nodes_in_group("Card")
			if cards_on_board.size() < 3:
				var card_instance = card.instance()
				add_child(card_instance)
				get_node("/root/Board/AudioHandler/pickupPlayer").play(0) #play the sound!
				can_draw = false
