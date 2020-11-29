extends Area2D

var quantity = 5

func pickup(is_network_master):
	if is_network_master:
		if Globals.logsValue + quantity <= 25:
			Globals.logsValue += quantity
			EventBus.emit_signal("update_logs_value", Globals.logsValue)
			rpc("remove")

remotesync func remove():
	queue_free()
