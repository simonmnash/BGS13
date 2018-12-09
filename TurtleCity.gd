extends TileMap

var current_max_height = 0
var probability = 0

func _ready():
	# Init an full row of cells (each cell is 4 by 4 right now as a performance hedge, we can probably get them down to 2x2 at least (probably even do single pixels)).
	for i in range(-35,145):

		if (randi() % 2)==0:
			self.set_cell(i, 0, 0)
	current_max_height = current_max_height + 1


func growth(growth_decay, wonder_tradition, order_chaos):
	print(growth_decay)
	if growth_decay > 0:
		for j in range(0, current_max_height):
			for i in range(-35,145):
				if should_turn_this_cell_on(i, j, current_max_height, growth_decay, wonder_tradition, order_chaos):
					# A little randomness makes the structure a little cooler looking in my opinion. Probably change
					# based on card parameters.
					if (randi() % 2)==0:
						self.set_cell(i, j, 0)
		current_max_height = current_max_height + 1
	else:
		# To make decay look (a little natural), we run it top (current max height) to bottom instead of bottom to top. We also limit the number of rows
		# hit by decay based on the growth_decay score of the played card.
		
		# Even though we run bottom to top we are still looking at the row below to determine whether to decay.
		var rows_to_decay = range(current_max_height+(2*(growth_decay-1)), current_max_height)
		# Invert returns void, so we don't set an array based on it, it just inverts rows_to_decay in place.
		rows_to_decay.invert()
		for j in rows_to_decay:
			for i in range(-35,145):
				if should_turn_this_cell_off(i, j, current_max_height, growth_decay, wonder_tradition, order_chaos):
					# Note: We might not want this long term, it is here now because the (placeholder) decay rule
					# will always decay the bottom row, since the "bottom" row is on top of an all off row. 
					if (randi() % 2)==0:
						self.set_cell(i, j, -1)


# This is a placeholder CA function.
# Two major things we want to change:
# 1) Right now rules are static (000->0, 011->0, 111->0). Ideally we want to replace this with dyanm
func should_turn_this_cell_on(i, j, max_height, grow_decay, wonder_tradition, order_chaos):
	# This is a little unconventional, CA convention is to use 0 as off and 1 as on, but godot uses -1 as off for a tilemap,
	# so 0 is the first kind of tile in the tilemap.
	
	# c00 c10 c20
	# c01 c11 c21
	# c02 c12 c22

	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	var on = true

	if not c02 and not c12 and not c22:
		on = false
	elif not c02 and c12 and c22:
		on = false
	elif c02 and c12 and c22:
		on = false
			
	return on
	
	# THERE ARE SIX RULESETS. RULE 1 IS MOST "TRADITIONAL", RULE 6 IS MOST "WONDERFUL"

func rule_1(i, j, max_height, grow_decay, wonder_tradition, order_chaos):
	
	#BUILDS A LOT! tendency to totally fill in (class 1)
	
	# c00 c10 c20
	# c01 c11 c21
	# c02 c12 c22
	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	var on = true
	if not c02 and not c12 and not c22:
		on = false
		
	return on
	

func should_turn_this_cell_off(i, j, max_height, grow_decay, wonder_traditions, order_chaos):
	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	
	var off = false
	
	if not c12:
		off = true
	return off

func rule_2(i, j, max_height, grow_decay, wonder_tradition, order_chaos):
	
	#BUILDS STRAIGHT UP (class 2)
	
	# c00 c10 c20
	# c01 c11 c21
	# c02 c12 c22
	
	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	
	var on = true

	if not c12:
		on = false
	
		
	return on

func rule_3(i, j, max_height, grow_decay, wonder_tradition, order_chaos):
	
	#BUILDS SOME NICE DIAGONALS (class 2)
	
	# c00 c10 c20
	# c01 c11 c21
	# c02 c12 c22
	
	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	
	var on = true

	if c02 and c12 and not c22:
		on = false
	elif not c02 and c12 and not c22:
		on = false
	elif not c02 and not c12 and c22:
		on = false
	elif not c02 and not c12 and not c22:
		on = false
	
		
	return on

func rule_4(i, j, max_height, grow_decay, wonder_tradition, order_chaos):
	
	#THIS ONE MAKES PYRAMID-LIKE THINGS (class 3)
	
	# c00 c10 c20
	# c01 c11 c21
	# c02 c12 c22
	
	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	
	var on = true

	if not c02 and not c22:
		on = false
	elif not c02:
		on = false
	elif not c12 and not c22:
		on = false
	elif c02 and c12 and c22:
		on = false
	return on
	

func rule_5(i, j, max_height, grow_decay, wonder_tradition, order_chaos):
	
	#THIS ONE MAKES COOL RANDOM-ISH TRIANGLE-Y STUFF (RULE 30, class 3)
	
	# c00 c10 c20
	# c01 c11 c21
	# c02 c12 c22
	
	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	
	
	var on = true

	if c02 and c12 and c22:
		on = false
	elif c02 and c12 and not c22:
		on = false
	elif c02 and c22 and not c12:
		on = false
	elif not c02 and not c22 and not c12:
		on = false
		
	return on

func rule_6(i, j, max_height, grow_decay, wonder_tradition, order_chaos):
	
	#SERPINSKI! (rule 90, class 4)
	
	# c00 c10 c20
	# c01 c11 c21
	# c02 c12 c22
	
	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	
	var on = true

	if c02 and c12 and c22:
		on = false
	elif c02 and not c12 and c22:
		on = false
	if not c02 and c12 and not c22:
		on = false
	if not c02 and not c12 and not c22:
		on = false
	return on
