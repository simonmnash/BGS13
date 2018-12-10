extends Node2D

var day_count = 0;


# Positive is growth. Negative is decay.
var growth_decay = 0 
# Positive is wonder. Negative is tradition.
var wonder_tradition = 0
# Positive is order. Negative is chaos.
var order_chaos = 0

var layers_grown = 0

var layers_to_grow = 6


signal stop_growth

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _on_StartCycleButton_start_growth():
	var cards_on_board = get_tree().get_nodes_in_group("Card")
	var growth_decay_card = get_tree().get_root().find_node("GrowthDecaySlot", true, false).get_overlapping_areas()[0]
	var wonder_tradition_card = get_tree().get_root().find_node("WonderTraditionSlot", true, false).get_overlapping_areas()[0]
	var order_chaos_card = 	get_tree().get_root().find_node("OrderChaosSlot", true, false).get_overlapping_areas()[0]
	for card in cards_on_board:
		card.queue_free()
	growth_decay = growth_decay_card.card_order
	wonder_tradition = wonder_tradition_card.card_order
	order_chaos = order_chaos_card.card_order
	
	if growth_decay == 3:
		layers_to_grow = 12
	elif growth_decay == 2:
		layers_to_grow = 9
	elif growth_decay == 1:
		layers_to_grow = 6
	else:
		layers_to_grow = 6

func _on_Timer_timeout():

	get_node("AudioHandler").masterPitch = rand_range(0.8888, 1.2222)
	get_node("AudioHandler")._resetPitch()
	
	get_node("AudioHandler").chaos = order_chaos
	get_node("AudioHandler").wonder = wonder_tradition
	get_node("AudioHandler").decay = growth_decay
	
	get_node("AudioHandler")._playAmbience()
	
	# Build a new layers at the end of the day.
	if layers_grown < layers_to_grow:
		get_tree().get_root().find_node("TurtleCity", true, false).growth(growth_decay, wonder_tradition, order_chaos)
		layers_grown = layers_grown + 1
	else:
		layers_grown = 0
		emit_signal("stop_growth")
		get_tree().get_root().find_node("Deck", true, false).reprime_draw()
		

func _on_ScreenshotTimer_timeout():
	# get screen capture
	var capture = get_viewport().get_texture().get_data()
	# save to a file
	print("captured")
	capture.save_png("preserved.png")
	get_tree().change_scene("res://TitleScreen.tscn")