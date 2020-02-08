extends Node2D

var Start = false
var Intro = 0
var fade = false #Used to make MenuTween play once
#Intro here
func _ready():
	$intro.set("visibe", Color(1,1,1,0))
	$IntroTween.interpolate_property($intro, "modulate", Color(1,1,1,0), Color(1,1,1,1), 3,Tween.TRANS_LINEAR, Tween.EASE_IN,0)
	$IntroTween.start()

func _input(event):
	if event.as_text() == "Space":
		$MenuCamera.current = true

func _unhandled_key_input(event):
	if !event.is_pressed():
		$Secret.text = $Secret.text + event.as_text()

func _on_IntroTween_tween_all_completed():
	$IntroTween.interpolate_property($intro, "modulate", Color(1,1,1,1), Color(1,1,1,0), 3,Tween.TRANS_LINEAR, Tween.EASE_IN,5)
	$IntroTween.start()

func _on_IntroTimer_timeout():
	$MenuCamera.current = true

func _process(delta):
	if $MenuCamera.current && !fade:
		fade = true
		$fade.set("visible", true)
		$MenuTween.interpolate_property($fade, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		$MenuTween.start()
	if "DEADAGAIN" in $Secret.text:
		$Secret.text = ""
		$DeadAgain.play()

func _on_Quit_pressed():
	get_tree().quit()


func _on_Continue_mouse_entered():
	$Continue/Tween.stop($Continue)
	$Continue.set("modulate", Color(0,1,0,1))
	$Continue/Tween.interpolate_property($Continue, "modulate", Color(0,1,0,1), Color(1,1,1,1), 0.3,Tween.TRANS_LINEAR,Tween.EASE_IN,0)
	$Continue/Tween.start()


func _on_Start_mouse_entered():
	$Start/Tween2.stop($Start)
	$Start.set("modulate", Color(0,1,0,1))
	$Start/Tween2.interpolate_property($Start, "modulate", Color(0,1,0,1), Color(1,1,1,1), 0.3,Tween.TRANS_LINEAR,Tween.EASE_IN,0)
	$Start/Tween2.start()

func _on_Options_mouse_entered():
	$Options/Tween3.stop($Options)
	$Options.set("modulate", Color(0,1,0,1))
	$Options/Tween3.interpolate_property($Options, "modulate", Color(0,1,0,1), Color(1,1,1,1), 0.3,Tween.TRANS_LINEAR,Tween.EASE_IN,0)
	$Options/Tween3.start()


func _on_Quit_mouse_entered():
	$Quit/Tween4.stop($Quit)
	$Quit.set("modulate", Color(0,1,0,1))
	$Quit/Tween4.interpolate_property($Quit, "modulate", Color(0,1,0,1), Color(1,1,1,1), 0.3,Tween.TRANS_LINEAR,Tween.EASE_IN,0)
	$Quit/Tween4.start()


func _on_Start_pressed():
	Start = true
