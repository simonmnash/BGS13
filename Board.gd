extends Node2D

var day_count = 0;


# Positive is growth. Negative is decay.
var growth_decay = 0 
# Positive is wonder. Negative is tradition.
var wonder_tradition = 0
# Positive is order. Negative is chaos.
var order_chaos = 0


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func end_day():
	day_count = day_count + 1;
	var growth_decay_card = get_tree().get_root().find_node("GrowthDecaySlot", true, false).get_overlapping_areas()[0]
	var wonder_tradition_card = get_tree().get_root().find_node("WonderTraditionSlot", true, false).get_overlapping_areas()[0]
	var order_chaos_card = 	get_tree().get_root().find_node("OrderChaosSlot", true, false).get_overlapping_areas()[0]

	growth_decay = growth_decay_card.card_order
	wonder_tradition = wonder_tradition_card.card_order
	order_chaos = order_chaos_card.card_order
	
	get_node("AudioHandler").masterPitch = rand_range(0.8888, 1.2222)
	get_node("AudioHandler")._resetPitch()
	
	get_node("AudioHandler").chaos = order_chaos_card.card_order
	get_node("AudioHandler").wonder = wonder_tradition_card.card_order
	get_node("AudioHandler").decay = growth_decay_card.card_order
	
	get_node("AudioHandler")._playAmbience()
	
	# Build a few new layers at the end of the day.
	for i in range(0, 3):
		get_tree().get_root().find_node("TurtleCity", true, false).growth(growth_decay, wonder_tradition, order_chaos)
	