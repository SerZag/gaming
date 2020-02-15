extends Spatial

export var max_health = 100
var hp = max_health

func _process(delta):
	if hp <= 0:
		get_tree().queue_delete(self)

func take_damage(dmg):
	hp -= dmg

func on_use():
	var manager = get_node("..")
	manager.call("open_door")
