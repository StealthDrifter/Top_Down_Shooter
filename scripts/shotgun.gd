extends Node2D

var devShotgun = load("res://Assets/power ups/shotgun/Shotgun.png")
var spaceShotgun = load("res://Assets/power ups/shotgun/SGI.png")
var tankShotgun = load("res://Assets/power ups/shotgun/tankShotgun.png")
var sec = 0
@onready var sprite = $Sprite2D

func _process(_delta):
	if sec >= 10:
		queue_free()
	match global.world:
		0:
			sprite.texture = devShotgun
		1:
			sprite.texture = spaceShotgun
		2:
			sprite.texture = tankShotgun

func _on_detect_collect_body_entered(body):
	if body.has_method("player"):
		global.shotgun = !global.shotgun
		print("Rip and Tear")
		queue_free()
		


func _on_timer_timeout():
	sec += 1
