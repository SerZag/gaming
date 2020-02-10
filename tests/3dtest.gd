extends Spatial

var secret = 0

func _process(delta):
	if secret == 3:
		$secret.play()
		secret = 0
	print(secret)

func open_door():
