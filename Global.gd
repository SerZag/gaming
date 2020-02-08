extends Node2D

func _input(event):
	if event.as_text() == "Escape":
		get_tree().quit()
