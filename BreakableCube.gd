extends Spatial

export var max_health = 100
var hp = max_health
var used = false

func _process(delta):
	if hp <= 0:
		get_tree().queue_delete(self)

func take_damage(dmg):
	hp -= dmg

func on_use():
	if !used:
		var manager = get_node("..")
		manager.secret += 1
		manager.call("open_door")
		used = true
