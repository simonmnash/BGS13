extends TileMap

var current_max_height = 0
var current_actual_height = 0
var population_of_top_row = 0.0
var probability = 0
var cellCount = 0

func _ready():
	# Init an full row of cells (each cell is 4 by 4 right now as a performance hedge, we can probably get them down to 2x2 at least (probably even do single pixels)).
	for i in range(-35,145):

		if (randi() % 2)==0:
			self.set_cell(i, 0, 0)
			
	current_actual_height = current_actual_height + 1

	
func growth(growth_decay, wonder_tradition, order_chaos):
	population_of_top_row = 0
	var chance = 0
	var chanceCount = 0.0
	var passCount = 0.0
	var chancePercentage = 0.0
	
	if growth_decay > 0:
		for j in range(floor(current_actual_height/2), current_actual_height+1): #growth can only propagate from halfway up your structure. This solves the problem of whole-structure-filling, and makes more interesting results
			for i in range(-35,145):
				
				match order_chaos:
						-3:
							chance = 10
						-2:
							chance = 25
						-1:
							chance = 50
						0:
							chance = 100
						1:
							chance = 100
						2:
							chance = 100
						3:
							chance = 100
				
				# I made the chaos variable influence which wonder_tradition rule is picked for each cell.
				# this way, "ORDER" makes growth & decay predictably follow their rules, while "CHAOS" makes them behave more strangely
							
				var new_wonder_tradition = wonder_tradition 
				if (randi() % 100) < chance:
					new_wonder_tradition = wonder_tradition
					chanceCount = 1 + chanceCount
				else:
					new_wonder_tradition = round(rand_range(-3, 3))
				passCount = passCount + 1
				
				if should_turn_this_cell_on(i, j, current_actual_height, growth_decay, new_wonder_tradition, order_chaos):

					self.set_cell(i, j, 0)
					# Keep track of how many cells are in the top row
					if j == current_actual_height:
						population_of_top_row = population_of_top_row + 1

					
		
		if population_of_top_row > 0:
			# If we've added any cells to the top row, keep growing!
			current_actual_height = current_actual_height + 1
		else:
			# If our growth rule has stopped adding rows, exit the growth cycle!
			get_node("/root/Board").layers_to_grow = 0
			current_actual_height = current_actual_height
		current_max_height = current_max_height + 1
	else:
		for k in range(-35, 145):
			if get_cell(k, current_actual_height) == 0:
				population_of_top_row = population_of_top_row + 1
		
		# To make decay look (a little natural), we run it top (current actual height) to bottom instead of bottom to top. We also limit the number of rows
		# hit by decay based on the growth_decay score of the played card.
		
		# Even though we run bottom to top we are still looking at the row below to determine whether to decay.
		var rows_to_decay = range(current_actual_height+(2*(growth_decay-1)), current_actual_height)
		# Invert returns void, so we don't set an array based on it, it just inverts rows_to_decay in place.
		rows_to_decay.invert()
		for j in rows_to_decay:
			
			var cells_killed_this_pass = 0
			
			for i in range(-35,145):
				var new_wonder_tradition = wonder_tradition
				match order_chaos:
						-3:
							chance = 10
						-2:
							chance = 25
						-1:
							chance = 50
						0:
							chance = 100
						1:
							chance = 100
						2:
							chance = 100
						3:
							chance = 100
				
				# Again, like in growth cycles, CHAOS now has a chance of randomizing wonder_tradition (which rule gets followed)
				if (randi() % 100) < chance:
					new_wonder_tradition = wonder_tradition
					chanceCount = 1 + chanceCount
				else:
					new_wonder_tradition = round(rand_range(-3, 3))
				passCount = passCount + 1
				
				if should_turn_this_cell_off(i, j, current_actual_height+1, growth_decay, new_wonder_tradition, order_chaos):

					self.set_cell(i, j, -1)
					cells_killed_this_pass = cells_killed_this_pass + 1
					# if we kill a cell in the top row, keep track of how many are left
					if j == current_actual_height-1:
						population_of_top_row = population_of_top_row - 1
						
			if cells_killed_this_pass == 0:
				rows_to_decay = range(j, j)			
					
		rows_to_decay.invert()
		for j in rows_to_decay:
			for i in range(-35,145):
				if kill_lone_cells(i, j):
					self.set_cell(i, j, -1)
		
		# actual_height variable decreases if the entire top row is killed
		if population_of_top_row == 0:
			current_actual_height = current_actual_height - 1	
		
		
	#keeps track of total cells alive, ends game if 0
	cellCount = 0
	for j in range(0, current_actual_height):
			for i in range(-35,145):
				var thisCell = get_cell(i, j)
				if thisCell == 0:
					cellCount = cellCount + 1
				else:
					cellCount = cellCount
	if cellCount <= 0:
		gameOver()

func should_turn_this_cell_on(i, j, max_height, grow_decay, wonder_tradition, order_chaos):
	
	var on = false
	# This is a little unconventional, CA convention is to use 0 as off and 1 as on, but godot uses -1 as off for a tilemap,
	# so 0 is the first kind of tile in the tilemap.
	
	# cell positions:
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

	match wonder_tradition:
		-3:
			on = rule_6(i, j)
		-2:
			on = rule_5(i, j)
		-1:
			on = rule_4(i, j, c00, c10, c20, c02, c12, c22, c01, c21)
		0:
			on = rule_0(i, j, c00, c10, c20, c02, c12, c22, c01, c21)
		1:
			on = rule_3(i, j, c00, c10, c20, c02, c12, c22, c01, c21)
		2:
			on = rule_2(i, j)
		3:
			on = rule_1(i, j, c00, c10, c20, c02, c12, c22, c01, c21)
			
	return on
	
	# THERE ARE SIX RULESETS. RULE 1 IS MOST "TRADITIONAL", RULE 6 IS MOST "WONDERFUL"

func should_turn_this_cell_off(i, j, max_height, grow_decay, wonder_tradition, order_chaos):

	var off = false
	# cell positions:
		# c02 c12 c22	
		# c01 c11 c21
		# c00 c10 c20
	
	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	
	match wonder_tradition:
		-3:
			off = rule_6(i, j)
		-2:
			off = rule_5(i, j)
		-1:
			off = rule_4(i, j, c00, c10, c20, c02, c12, c22, c01, c21)
		0:
			off = rule_0(i, j, c00, c10, c20, c02, c12, c22, c01, c21)
		1:
			off = rule_3(i, j, c00, c10, c20, c02, c12, c22, c01, c21)
		2:
			off = rule_2(i, j)
		3:
			off = rule_1(i, j, c00, c10, c20, c02, c12, c22, c01, c21)
		
		
	return off

func kill_lone_cells(i, j): #this should run after the decay cycle to take care of sad lonely boys
	var off = false
	
	var c02 = self.get_cell(i-1, j-1)==0
	var c12 = self.get_cell(i, j-1)==0
	var c22 = self.get_cell(i+1, j-1)==0
	var c00 = self.get_cell(i-1, j+1)==0
	var c10 = self.get_cell(i, j+1)==0
	var c20 = self.get_cell(i+1, j+1)==0
	var c01 = self.get_cell(i-1, j)==0
	var c21 = self.get_cell(i+1, j)==0
	
	if not c02 and not c12 and not c22 and not c00 and not c10 and not c20 and not c01 and not c21:
		off = true
		
	return off

# Generic function to apply an elementary cellular automota rule.
# Accepts two integer coordinates (i, j), and an boolean array of length 8.
# Returns a boolean of whether to turn on cell i, j.
# Uses the binary rule format described on http://mathworld.wolfram.com/topics/CellularAutomata.html
func run_elementary_ca_rule(i, j, rule):
	var c0 = self.get_cell(i-1, j-1)==0
	var c1 = self.get_cell(i, j-1)==0
	var c2 = self.get_cell(i+1, j-1)==0
	
	if c0 and c1 and c2:
		return rule[0]
	elif c0 and c1 and not c2:
		return rule[1]
	elif c0 and not c1 and c2:
		return rule[2]
	elif c0 and not c1 and not c2:
		return rule[3]
	elif not c0 and c1 and c2:
		return rule[4]
	elif not c0 and c1 and not c2:
		return rule[5]
	elif not c0 and not c1 and c2:
		return rule[6]
	elif not c0 and not c1 and not c2:
		return rule[7]


# Example function that uses run_elemntary_ca_rule.
# Picks a random rule in a boolean array format and applies it.
func totally_random_rule(i, j):
	var random_rule = [bool(randi() % 2), bool(randi() % 2), bool(randi() % 2), bool(randi() % 2), bool(randi() % 2), bool(randi() % 2), bool(randi() % 2), bool(randi() % 2)]
	return run_elementary_ca_rule(i, j, random_rule)
	
func rule_0(i, j, c00, c10, c20, c02, c12, c22, c01, c21):
	
	#some nice symmetrical pyramids (this rule only gets called sometimes during chaos

	var on = true
	
	if c02 and c12 and not c22:
		on = false
	elif c02 and not c12 and c22:
		on = false
	elif c02 and not c12 and not c22:
		on = false
	elif not c02 and c12 and c22:
		on = false
	elif not c02 and c12 and not c22:
		on = false
		
	return on

func rule_1(i, j, c00, c10, c20, c02, c12, c22, c01, c21):
	
	#BUILDS A LOT!
	
	var on = true
	if not c12:
		on = false
	
		
	return on

func rule_2(i, j):
	#CA rule 28, builds diagonally
	var rule_28 = [false, false, false, true, true, true, false, false]
	return run_elementary_ca_rule(i, j, rule_28)


func rule_3(i, j, c00, c10, c20, c02, c12, c22, c01, c21):
	
	#BUILDS SOME NICE DIAGONALS (class 2)

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

func rule_4(i, j, c00, c10, c20, c02, c12, c22, c01, c21):
	#THIS ONE MAKES PYRAMID-LIKE THINGS (class 3)

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
	

func rule_5(i, j):
	#THIS ONE MAKES COOL RANDOM-ISH TRIANGLE-Y STUFF (RULE 30, class 3)
	var rule_30 = [false, false, false, true, true, true, true, false]
	return run_elementary_ca_rule(i, j, rule_30)

func rule_6(i, j):
	#SERPINSKI! (rule 90, class 4)
	var rule_90 = [false, true, false, true, true, false,true, false]
	return run_elementary_ca_rule(i, j, rule_90)


func gameOver():
	get_tree().change_scene("res://EndScreen.tscn")