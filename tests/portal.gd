extends Spatial

var inside = false

func _on_Area_body_entered(body):
	if body.get_name() == "Player" && !inside:
		$Player.translation.x += -21 * 2
		inside = true

func _on_Area2_body_entered(body):
	if body.get_name() == "Player" && !inside:
		$Player.translation.x += 21 * 2
