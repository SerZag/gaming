extends Node2D
var t = 0
func _physics_process(delta):
	t += delta * 0.4
	if $Sprite.position != $B.position:
		$Sprite.position = $A.position.linear_interpolate($B.position, t)
