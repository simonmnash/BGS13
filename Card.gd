extends Area2D

var x = 0
var y = 0
var lifted = false
var disabled = false

var card_types = ["scissiors", "rock", "paper"]

func _ready():
	$front.animation = card_types[randi() % card_types.size()]
	pass



func _unhandled_input(event):


	if lifted and not disabled and event is InputEventMouseMotion:
		position += event.relative

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if lifted and not disabled:
			var areas = self.get_overlapping_areas()
			print (areas)
			for area in areas:
				if area.is_in_group("Slot"):
					var old_parent = self.get_parent()
					var new_parent = area
					lifted = false
					disabled = true
					get_tree().get_root().find_node("Deck", true, false).reprime_draw()
		else:
			lifted = true
			