extends Area2D

func pickup():
	if Globals.logsValue <= 20:
		Globals.logsValue += 5
		queue_free()
