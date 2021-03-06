extends Area2D

var x = 0
var y = 0
var lifted = false
var disabled = false
var card_order = 0
var card_types = ["turtles_1", "turtles_2", "turtles_3"]

func _ready():
	randomize()
	var card_type = randi() % card_types.size()
	$front.animation = card_types[card_type]
	card_order = card_type + 1
	if (randi() % 2)==0:
		card_order = card_order * -1
		self.rotate(3.14)


func drop_card_into_area(area):
	# Ideally we can add the cards as children nodes on the slots. For now, just freeze them on the slots.
	var old_parent = self.get_parent()
	var new_parent = area
	
	get_node("/root/Board/AudioHandler/putdownPlayer").play(0) #play the sound!
	
	lifted = false
	disabled = true
	# There is probably a more efficent way to find the deck, but this isn't a bottleneck at the moment and probably won't ever become one.
	var cards_on_board = get_tree().get_nodes_in_group("Card")
	print(cards_on_board)
	if cards_on_board.size() < 3:
		get_tree().get_root().find_node("Deck", true, false).reprime_draw()
	elif cards_on_board.size()==3:
		print("highlight")
		get_tree().get_root().find_node("FortellHighlight", true, false).show()
		


func _unhandled_input(event):
	if lifted and not disabled and event is InputEventMouseMotion:
		position += event.relative

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if lifted and not disabled:
			# Find all of the areas that overlap this card after it is placed
			var areas = self.get_overlapping_areas()
			for area in areas:
				# If the area is a slot, then drop the card and disable it so it can't be removed, and reprime the deck for another draw.
				if area.is_in_group("Slot"):
					self.drop_card_into_area(area)

		else:
			lifted = true
			