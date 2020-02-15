	extends KinematicBody

#To do list
#Оружие,




#Переменные(чутка многовато)
export var max_health = 100
export var health = 100
export var gravity = 1
export var move_speed = 15
export var jump_height = 20
export var mouse_sensivity = 0.7
export var sprint_scale = 2
export var stamina_max = 100
export var fall_damage_mult = 1
export var in_control = true

#Переменные для оружия (используй словари!)
#P.S. Словарь - эт как массив, только можно подписывать значения
var pistol = {
	"name": "Assault Rifle",
	"mode": 1,
	"min_recoil": 0.02,
	"max_recoil": 0.04,
	"x_recoil_mult": 1.5,
	"fire_rate": 0.07,
	"reload_time": 1.2,
	"sound": "res://m4/G36_FIRE_3rdP.wav",
	"dmg": 13,
	"slot": 1,
	"clip_ammo": 30,
	"caliber": "357 Magnum",
}

var inv = {
	"357 Magnum": 24
}
var cur_wpn = pistol
var grabbed = false #WIP!
var min_fall_damage_speed = 55
var stamina_buff = 0
var regen_stamina = false
var stamina = 100
var sprint = false
var y_motion = 0
var stanging = false
var duck = false
var mouse_motion = Vector2()
var t = 0
var crouched = false
var motion = Vector3()
var y_velocity = 0
var can_shoot = true
var reloading = false
var clip_ammo = 0
var circle_size = 1
var shoot_pitch = 1

#Обекты
# $Camera - камера игрока
# $CollisionShape - форма столкновения в стоячем положении
# $DuckCollisionShape - форма столкновения в сидячем положении
# $CollisionShape2 - форма для предватращения вдаваливания в пол при приседании
# $CollisionRay - луч для проверки нахождения на земле
# $CollisionRay2 - луч для проверки присутствия потолока во время приседа
# $StandingCamPos - не используется
# $DuckCamPos - не используется
# $CamSmoothingUp - tween для анимации вставания
# $CamSmoothingDown - tween для анимации присед
# $grabray - луч для проверки захвата
# $viewray - луч на уровне глаз для много чего
# $camray - луч для стрельбы

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	$hptext.text = str(health)

func _physics_process(delta):
	if !in_control:
		return
	
	
	
	var motion_direction = Vector3()
	
	#Уничтожение зависимости от FPS
	var d = delta * 60 
	t = delta *0.4
	
	#Установление направления
	motion_direction = _axis() * move_speed
	rotate_y(deg2rad(20) * -mouse_motion.x * mouse_sensivity * delta)
	$Camera.rotate_x(deg2rad(20) *-mouse_motion.y * mouse_sensivity * delta)
	$Camera.rotation.x = clamp($Camera.rotation.x, deg2rad(-90), deg2rad(90))
	
	mouse_motion = Vector3() #Очистка вектора движения мыши
	
	y_motion = y_motion - gravity * d #Расчёт вертикальной скорости
	y_velocity = y_motion
	
	if $CollisionRay.is_colliding() && y_velocity < -min_fall_damage_speed:
		take_damage(int((abs(y_velocity) - min_fall_damage_speed) * fall_damage_mult))
		y_velocity = 0
	
	#Проверка нахождения на земле
	if $CollisionRay.is_colliding(): 
		stanging = true
	if !$CollisionRay.is_colliding():
		stanging = false
	
	#Прыжок
	if Input.is_action_just_pressed("jump") && stanging && stamina >= 10:
		stamina -= 10
		stamina_buff = 0
		y_velocity = jump_height #Добавление jump_height к вертикальной скорости
	
#	#Лазанье (Временно отключено т.к. не вписывается в геимплей)
#	grabbed = false
#	if !$viewray.is_colliding() && $grabray.is_colliding() && stanging == false:
#		grabbed = true
#	if grabbed:
#		y_velocity = 0
#	if grabbed:
#		motion_direction = motion_direction * 0.2
#	if grabbed && Input.is_action_just_pressed("jump"):
#		$grabray.enabled = false
#		y_velocity = jump_height
#	if stanging && y_motion < 0:
#		$grabray.enabled = true
	
	#Атака
	#TO DO:
	# Сделать слоты для оружия и патроны
	if Input.is_action_pressed("attack"):
		shoot(cur_wpn)
	if clip_ammo != cur_wpn.clip_ammo && Input.is_action_pressed("reloading"):
		reloading = true
	if reloading && $Reload_timer.is_stopped():
		$Reload_timer.start(cur_wpn.reload_time)
	$crosscircle.scale = Vector2(circle_size, circle_size)
	if circle_size > 1:
		circle_size -= 0.01
	if circle_size < 1:
		circle_size = 1
	$ammotext.bbcode_text = "[center]" + str(clip_ammo) + "/" + str(cur_wpn.clip_ammo)
	$wpntext.bbcode_text = "[center]" + cur_wpn.name
	
	#Взаимодействие
	if Input.is_action_just_pressed("use"):
		print(use())
	
	#Спринт
	if Input.is_action_pressed("sprint") && !duck && _axis() != Vector3(0,0,0):
		sprint = true
	if !Input.is_action_pressed("sprint") || _axis() == Vector3(0,0,0):
		sprint = false
	if sprint:
		stamina -= d * 0.4
		if stamina > 0:
			motion_direction = _axis() * move_speed * sprint_scale
	if !sprint && stamina != 100 && stamina_buff != 100:
		stamina_buff += d
	if stamina_buff == 100 && !sprint:
		regen_stamina = true
	if stamina_buff != 100:
		regen_stamina = false
	if regen_stamina:
		stamina += d
	if sprint:
		stamina_buff = 0
	stamina_buff = clamp(stamina_buff, 0, stamina_max)
	stamina = clamp(stamina, 0, stamina_max)
	if stamina <= 50:
		var a = (100-stamina*2)*0.01
		$stamina_drain.modulate = Color(1,1,1,a)
	if stamina > 50:
		$stamina_drain.modulate = Color(1,1,1,0)
	if stamina == 0:
		motion_direction = motion_direction * 0.5
	
	if health <= 25:
		var a = (100-health*4)*0.01
		$low_health.modulate = Color(1,1,1,a)
	if health > 25:
		$low_health.modulate = Color(1,1,1,0)
	
	#Приседание
	if Input.is_action_just_pressed("duck"):
		duckdown()
	if Input.is_action_just_released("duck") && !$CollisionRay2.is_colliding():
		duckup()
	if $CollisionShape.disabled && !$CollisionRay2.is_colliding() && !Input.is_action_pressed("duck"):
		duckup()
	if duck:
		motion_direction = motion_direction * 0.4 #Урезание скорости во время приседа
		$CollisionShape.disabled = true #Выключение CollisionShape для уменьшания размера игрока
	if !duck:
		$CollisionShape.disabled = false #Возрат в нормальное состояние
	
	motion = Vector3(motion_direction.x,y_velocity,motion_direction.z) #Сложение всего в одну переменную
	y_motion = move_and_slide(motion).y #Расчёт вертикальной скорости (move_and_slide возвращает скорость)
	
#	#Дебаг
#	print(stamina)
	
	move_and_slide(motion) #Движение игрока

func _input(event): 
	if event.get_class() == "InputEventMouseMotion":
		mouse_motion = event.relative #Установление mouse_motion на Vector2 относительно положения мыши в предыдущем кадре

func _axis(): #Расчёт направления
	var direction = Vector3() #Очистка direction
	
	if Input.is_action_pressed("move_forward"):
		direction -= get_global_transform().basis.z.normalized()
		
	if Input.is_action_pressed("move_backwards"):
		direction += get_global_transform().basis.z.normalized()
		
	if Input.is_action_pressed("strafe_left"):
		direction -= get_global_transform().basis.x.normalized()
		
	if Input.is_action_pressed("strafe_right"):
		direction += get_global_transform().basis.x.normalized()
		
	return direction.normalized()

func duckup(): #Анимация вставания
	$CamSmoothingUp.interpolate_property($Camera, "translation", Vector3(0,-3,0), Vector3(0,3,0), 0.2,Tween.TRANS_LINEAR,Tween.EASE_IN,0)
	$CamSmoothingUp.start()
	duck = false

func duckdown(): #Анимация приседа
	$CamSmoothingDown.interpolate_property($Camera, "translation", Vector3(0,3,0), Vector3(0,-3,0), 0.2,Tween.TRANS_LINEAR,Tween.EASE_IN,0)
	$CamSmoothingDown.start()

func _on_CamSmoothingDown_tween_all_completed():
	duck = true

func take_damage(dmg):
	health = health - dmg

func shoot(wpn):
	if !can_shoot || reloading || clip_ammo == 0:
		return
		
		
	
	var sound = load(wpn["sound"])
	var ray = $Camera/camray
	var collider = ray.get_collider()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$Camera.rotate_x(rng.randf_range(wpn["min_recoil"], wpn["max_recoil"]))
	$Camera.rotation.x = clamp($Camera.rotation.x, deg2rad(-90), deg2rad(90))
	rng.randomize()
	var y = rng.randf_range(wpn["max_recoil"]*-1, wpn["max_recoil"]) * wpn["x_recoil_mult"]
	rotate_y(y)
	$ShootingSound.stream = sound
	rng.randomize()
	$ShootingSound.pitch_scale = rng.randf_range(0.85,1.0)
	$ShootingSound.play()
	if collider != null && collider.has_method("take_damage"):
		collider.call("take_damage",wpn["dmg"])
	can_shoot = false
	$Fire_timer.start(wpn["fire_rate"])
	if wpn["mode"] == 0:
		Input.action_release("attack")
	clip_ammo -= 1
	Node.new()
	circle_size += wpn["max_recoil"] * 2 



func use():
	var ray = $Camera/useray
	if !ray.is_colliding():
		return "Nope"
	if ray.get_collider() != null && ray.get_collider().has_method("on_use"):
		ray.get_collider().call("on_use")
		return "Used " + str(ray.get_collider())



func _on_Fire_timer_timeout():
	can_shoot = true


func _on_Reload_timer_timeout():
	var wpn = cur_wpn
	reloading = false
	clip_ammo = wpn["clip_ammo"]
	$Reload_timer.stop()
	print("bal")
