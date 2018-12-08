extends Area2D

var x = 0
var y = 0

var card_types = ["scissiors", "rock", "paper"]

func _ready():
	$front.animation = card_types[randi() % card_types.size()]
	self.translate(Vector2(rand_range(-100,-500),rand_range(-100,-500)))
	pass

var lifted = false

func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed:
		lifted = false
	if lifted and event is InputEventMouseMotion:
		position += event.relative

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		lifted = true