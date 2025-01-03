extends CharacterBody2D

var devPlayer = load("res://Assets/player/player.png")
var spacePlayer = load("res://Assets/player/space dorito.png")
var tankPlayer = load("res://Assets/player/GreenTank.png")
@onready var sprite = $Sprite2D
var bulletPath = preload("res://scenes/bullet.tscn")
var dir: Vector2
@onready var shots = $shots
var paused = global.paused
var n = false

func _ready():
	global.playerBody = self

func _physics_process(_delta):
	
	if global.score >= 50:
		global.shotgun = false
		
	if global.speed >= 400 and global.score >= 50:
		global.speed = 400
	velocity = dir * global.speed
	if Input.is_action_just_pressed("left_mouse_button"):
		if global.shotgun == true:
			shotgun()
		else:
			shoot()
	if paused == false:
		look_at(get_global_mouse_position())
	match global.world:
		0:
			sprite.texture = devPlayer
		1:
			sprite.texture = spacePlayer
		2:
			sprite.texture = tankPlayer
	move_and_slide()

func player():
	pass

func _unhandled_input(_event: InputEvent):
	movement()


func movement():
	dir.x = Input.get_axis("left", "right")
	dir.y = Input.get_axis("up", "down")
	dir = dir.normalized()
	
func shoot():
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	shots.playing = n
	bullet.position = $Marker2D.global_position
	bullet.dir = get_global_mouse_position() - bullet.position
	print(global.paused)
	
func shotgun():
	var aim_direction = global_position.direction_to(get_global_mouse_position())
	for angle in [-45, -22.5, 0, 22.5, 45]:
		var radians = deg_to_rad(angle)
		var bullet = bulletPath.instantiate()
		get_parent().add_child(bullet)
		bullet.dir = aim_direction.rotated(radians) - bullet.position
		bullet.position = $Marker2D.global_position
		shots.playing = n
		add_child(bullet)


func _on_detect_impact_body_entered(body):
	if body.has_method("enemy"):
		get_tree().change_scene_to_file("res://scenes/dead.tscn")
