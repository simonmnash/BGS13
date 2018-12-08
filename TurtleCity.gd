extends TileMap


var current_height = 0;

func _ready():
	# Init an full row of cells (each cell is 4 by 4 right now as a performance hedge, we can probably get them down to 2x2 at least (probably even do single pixels)).
	for i in range(0,100):
		self.set_cell(i, 0, 0)
	current_height = current_height + 1


# Draw a full row at the current height.
func generate_new_layer():
	for i in range(0,100):
		self.set_cell(i, self.current_height, 0)
	current_height = current_height + 1



# Do self referential calculations on any given row.
func evolve_row(height):
	pass