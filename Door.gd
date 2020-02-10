extends CSGCombiner

var open = false

func toggle_open():
	open = !open

func open():
	open = true

func close():
	open = false
