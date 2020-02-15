extends Spatial


func open_door():
	$Door.call("toggle_open")
