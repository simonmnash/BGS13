extends Timer

signal one_grow_cycle

func _ready():
	pass

func _on_StartCycleButton_start_growth():
	start()

func _on_Board_stop_growth():
	stop()
