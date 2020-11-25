extends Area2D

var quantity = 5

func pickup():
	if Globals.logsValue + quantity <= 25:
		Globals.logsValue += quantity
		queue_free()
