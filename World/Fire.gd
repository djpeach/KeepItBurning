extends Node2D

func interact():
		var overhead = Globals.fuelbarValue + Globals.logsValue - 100
		Globals.fuelbarValue = clamp(Globals.fuelbarValue + Globals.logsValue, 0, 100)
		Globals.logsValue = max(int(overhead), 0)
