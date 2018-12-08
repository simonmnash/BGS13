extends Area2D

var x = 0
var y = 0
var lifted = false
var disabled = false

var card_types = ["scissiors", "rock", "paper"]

func _ready():
	$front.animation = card_types[randi() % card_types.size()]
	self.translate(Vector2(rand_range(-100,-500),rand_range(-100,-500)))
	pass



func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed:
		lifted = false
		var areas = self.get_overlapping_areas()
		for area in areas:
			print(area)
			var old_parent = self.get_parent()
			var new_parent = area
			old_parent.remove_child(self)
			new_parent.add_child(self)
			area.print_tree()
			get_tree().get_root().find_node("Deck", true, false).reprime_draw()
	if lifted and event is InputEventMouseMotion:
		position += event.relative

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		lifted = true
		