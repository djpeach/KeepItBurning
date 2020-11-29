extends Node2D

func interact(is_network_master):
	if is_network_master:
		var overhead = Globals.fuelbarValue + Globals.logsValue - 100
		rpc("update_fuel_bar", clamp(Globals.fuelbarValue + Globals.logsValue, 0, 100))
		Globals.logsValue = max(int(overhead), 0)

remotesync func update_fuel_bar(val):
	Globals.fuelbarValue = val
