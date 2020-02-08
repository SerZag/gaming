extends KinematicBody2D
onready var spawnpoint = get_node("SpawnPoint")
var x_motion = 0
var x_speed = 0
var y_speed = 0
export var jump_height = 350
export var gravity = 10
export var move_speed = 100

func _ready():
	self.position == spawnpoint.position
func _physics_process(delta):
	var d = delta * 60
	if Input.is_key_pressed(KEY_RIGHT):
		x_motion = 1
	if Input.is_key_pressed(KEY_LEFT):
		x_motion = -1
	if !Input.is_key_pressed(KEY_RIGHT) && !Input.is_key_pressed(KEY_LEFT):
		x_motion = 0
	x_speed = move_speed * x_motion * d
	if !$GroundRay.is_colliding():
		y_speed = y_speed + gravity * d
	if $GroundRay.is_colliding():
		y_speed = 0
	if Input.is_key_pressed(KEY_UP) && $GroundRay.is_colliding():
		y_speed = -jump_height
	move_and_slide(Vector2(x_speed,y_speed))
