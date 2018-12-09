extends Timer

signal one_grow_cycle

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_StartCycleButton_start_growth():
	start()


func _on_Board_stop_growth():
	stop()
