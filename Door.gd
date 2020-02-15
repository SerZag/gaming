extends CSGCombiner

var open = false
var a = false

func on_use():
	print("This door was used")
	toggle_open()

func toggle_open():
		$Tween.interpolate_property(self, "scale",Vector3(1,1,1),Vector3(1,2,1), 0.5,Tween.TRANS_LINEAR,Tween.EASE_IN,0)
		$Tween.start()


#func open():
#	open = true
#	a = false
#
#func close():
#	open = false
#	a = false
