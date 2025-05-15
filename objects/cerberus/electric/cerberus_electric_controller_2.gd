extends CharacterBody2D

enum BossState { IDLE, WANDER }

var current_state: BossState = BossState.IDLE
var state_timer = 0.0
var attack_cooldown = 0.0
var speed = 100

var electric_ball_scene = preload("res://objects/cerberus/electric/electric_ball/pre_electric_ball.tscn")

var wander_points = [Vector2(200, 200), Vector2(400, 300), Vector2(400, 100)]
var current_target = Vector2.ZERO

@export var player: NodePath
var player_node

func _ready():
	if player:
		player_node = get_node(player)
	change_state(BossState.IDLE)

func _process(delta):
	match current_state:
		BossState.IDLE:
			state_timer -= delta
			if state_timer <= 0:
				change_state(BossState.WANDER)

		BossState.WANDER:
			move_towards_target(delta)
			if global_position.distance_to(current_target) < 10:
				change_state(BossState.IDLE)

	attack_cooldown -= delta
	if attack_cooldown <= 0 and player_node:
		var attack_type = randi() % 2  # 0, 1 o 2

		match attack_type:
			0:
				spawn_ball_at_player()
			1:
				spawn_ball_near_player()			
		attack_cooldown = 0.1  # dispara cada 2 segundos

func change_state(new_state: BossState):
	current_state = new_state
	match new_state:
		BossState.IDLE:
			state_timer = randf_range(1.0, 3.0)
		BossState.WANDER:
			current_target = wander_points[randi() % wander_points.size()]

func move_towards_target(delta):
	var dir = (current_target - global_position).normalized()
	velocity = dir * speed
	move_and_slide()
	update_animation()


func spawn_ball_at_player():
	if player_node:
		var ball = electric_ball_scene.instantiate()
		ball.global_position = player_node.global_position
		get_tree().current_scene.add_child(ball)

func spawn_ball_at_random_position():
	var ball = electric_ball_scene.instantiate()
	var x = randf_range(0, 800)  # ajusta al tamaño real de tu mapa
	var y = randf_range(0, 600)
	ball.global_position = Vector2(x, y)
	get_tree().current_scene.add_child(ball)

func spawn_ball_near_player():
	if not player_node:
		return
	var ball = electric_ball_scene.instantiate()
	var offset = Vector2(randf_range(-150, 150), randf_range(-150, 150))  # rango cercano
	ball.global_position = player_node.global_position + offset
	get_tree().current_scene.add_child(ball)
	
func update_animation():
	var particles = $cancerbero/GPUParticles2D2
	var material = particles.process_material as ParticleProcessMaterial
	if velocity.length() > 0:
		$cancerbero/AnimationPlayer.play("run")
	else:
		$cancerbero/AnimationPlayer.play("idle")
	if velocity.x != 0:
		$cancerbero/sprite.flip_h = velocity.x < 0		
		if velocity.x<0:
			material.emission_shape_offset = Vector3(7,0,0)
		else:
			material.emission_shape_offset = Vector3(-7,0,0)	
