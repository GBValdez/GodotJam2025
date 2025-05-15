extends ControllersCommons

enum BossState { IDLE, WANDER }

var current_state: BossState = BossState.IDLE
var state_timer = 0.0
var attack_cooldown = 0.0

var electric_ball_scene = preload("res://objects/cerberus/electric/electric_ball/pre_electric_ball.tscn")
var mirror_laser_scene = preload("res://objects/cerberus/electric/mirror_laser/mirror_laser.tscn")

var wander_points = [Vector2(200, 200), Vector2(400, 300), Vector2(400, 100)]
var current_target = Vector2.ZERO

func _ready():
	typeAttack = ["lightningHunt", "mirrorLaser"]
	change_state(BossState.IDLE)
	super._ready()
	self.attack = "lightningHunt"
	self.initAttack = true
	bulletScene = load("res://objects/cerberus/fire/balls_fire/ball_fire.tscn")

func _process(delta):
	match current_state:
		BossState.IDLE:
			state_timer -= delta
			if state_timer <= 0:
				change_state(BossState.WANDER)

		BossState.WANDER:
			move_towards_target()
			if cancerbero.global_position.distance_to(current_target) < 10:
				change_state(BossState.IDLE)

	if self.player:
		match attack:
			"lightningHunt":
				execute_lightning_hunt(delta)
			"mirrorLaser":
				execute_mirror_laser(delta)

func execute_lightning_hunt(delta):
	attack_cooldown -= delta
	if attack_cooldown <= 0:
		var attack_type = randi() % 2
		match attack_type:
			0:
				spawn_ball_at_player()
			1:
				spawn_ball_near_player()
		attack_cooldown = 0.1

func execute_mirror_laser(delta):
	attack_cooldown -= delta
	if attack_cooldown <= 0:
		launch_mirror_lasers(20)
		attack_cooldown = 2

func launch_mirror_lasers(amount: int = 3):
	var ball = electric_ball_scene.instantiate()
	var origin = $cancerbero/sprite/shotPointer.global_position
	ball.global_position = origin
	var level = get_tree().get_first_node_in_group("level")
	level.add_child(ball)
	for i in amount:
		var angle_deg = i * 20
		var angle = deg_to_rad(angle_deg)
		if origin != Vector2.ZERO:
			spawn_mirror_laser(origin, Vector2.RIGHT.rotated(angle))
		else:
			spawn_mirror_laser(player.global_position, Vector2.RIGHT.rotated(angle))
			spawn_mirror_laser($cancerbero/sprite/shotPointer.global_position, Vector2.RIGHT.rotated(angle))

func spawn_mirror_laser(pos: Vector2, direction: Vector2):
	var laser = mirror_laser_scene.instantiate()
	laser.global_position = pos
	laser.direction = direction
	var level = get_tree().get_first_node_in_group("level")
	level.add_child(laser)
	laser.call_deferred("calculate_and_draw_trajectory")

func change_state(new_state: BossState):
	current_state = new_state
	match new_state:
		BossState.IDLE:
			state_timer = randf_range(1.0, 3.0)
			cancerbero.direction = Vector2.ZERO
		BossState.WANDER:
			current_target = wander_points[randi() % wander_points.size()]

func move_towards_target():
	var direction = (current_target - cancerbero.global_position).normalized()
	cancerbero.direction = direction

func spawn_ball_at_player():
	if self.player:
		var ball = electric_ball_scene.instantiate()
		ball.global_position = self.player.global_position
		get_tree().current_scene.add_child(ball)

func spawn_ball_near_player():
	if not self.player:
		return
	var ball = electric_ball_scene.instantiate()
	var offset = Vector2(randf_range(-150, 150), randf_range(-150, 150))
	ball.global_position = self.player.global_position + offset
	get_tree().current_scene.add_child(ball)
