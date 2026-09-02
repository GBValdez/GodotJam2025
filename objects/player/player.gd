extends Entity
class_name  Player

const WALK_DOWN_TEXTURE = preload("res://objects/player/sprite/ps jam 32x32 caminando de frente-Sheet.png")
const WALK_UP_TEXTURE = preload("res://objects/player/sprite/ps jam 32x32  caminando espalda-Sheet.png")
const FACING_DEADZONE:float = 0.2
const ATTACK_LOCK_TIME:float = 0.42

@export_category("Controls")
@export var enableControl:bool=true
@export var speedDash: float = 10000;
var previousVelocity:Vector2=Vector2.ZERO
var buffer : bufferPlayer= bufferPlayer.new()
var currentDash:bool= false
var attackLock:float=0.0
var attackExtra:float=0;
var attackBase:float=15;
var attackBaseExtra:float=30;
var ultimeDirection:Vector2=Vector2.ZERO
@onready var inmorTimer:Timer= $inmortalidad
@onready var attackBar:attack_bar= $"attack-bar"

@export var blockMove:bool=false;
func _ready() -> void:
	anim.play("idle")
	JoystickGeneral.initJoysTick()

func onHitOther(body: Node2D):
	var enemy:enemyBasic=body.get_parent();
	if (enemy.is_in_group("entity")):
		var isDamage:bool= enemy.hitDamage(attackBase+(attackBaseExtra*attackExtra/100),global_position,enemy.forceHitMe,false)
		if isDamage:
			attackExtra+=2
			if attackExtra>=100:
				attackExtra=100
			attackBar.setCant(2.0/100.0)
			

func _process(delta: float) -> void:
	if health==0:
		return
	buffer.update(delta)
	if attackLock > 0.0:
		attackLock-=delta
		if attackLock <= 0.0:
			finish_attack_lock()
	elif blockMove and not currentDash and not is_attack_playing():
		finish_attack_lock()
	# Detectar entrada del jugador
	if (enableControl):
		direction = Vector2.ZERO
		if (not blockMove):
			if JoystickGeneral.joysticks.size()>0:
				direction= JoystickGeneral.joysticks[0].direccion
			else:
				direction.x = Input.get_axis("ui_left", "ui_right")
				direction.y = Input.get_axis("ui_up", "ui_down")
			if direction.length() > 0.2:
				ultimeDirection=direction
	direction = direction.normalized()
	# Aplicar movimiento basado en entrada
	velocity += direction * SPEED*delta	
	dash()
	attack()
	apply_inertia(delta,direction)
	apply_limit(delta) 
	#attempt_correction(5)
	previousVelocity=velocity
	move_and_slide()
	animation()

func moreAttack(damage):
	attackExtra+=3.5*damage
	attackBar.setCant(3.5/100)
	if attackExtra>=100:
		attackExtra=100
	else:
		animEffects.play("avalaible")
		General.createTimer(0.1,normalEffect)
func normalEffect():
	animEffects.play("normal")

func animation():
	if General.endGame:
		return
	if blockMove:
		return
	
	if velocity.length() > 0:
		if currentDash:
			var currentColor:Color=Color.WHITE
			currentColor.a=0.1
			General.spriteShadow(sprite,0.2,currentColor)
			#General.shakeCameraDir(0.5,0.1,velocity.normalized())
		else:	
			if abs(velocity.x)>LIMIT*0.1:
				anim.play("walk")
			else:
				if velocity.y<0:
					anim.play("walk_up")
				else:
					anim.play("walk_down")
		playSoundRandom(["audioStep","audioStep2","audioStep3"])
	else:
		if not currentDash:
			play_idle()

	if velocity.x!=0:
		sprite.scale.x= sign(velocity.x) * abs(sprite.scale.x) 

func play_idle():
	if abs(ultimeDirection.y) > abs(ultimeDirection.x) and abs(ultimeDirection.y) > FACING_DEADZONE:
		anim.stop()
		sprite.texture = WALK_UP_TEXTURE if ultimeDirection.y < 0 else WALK_DOWN_TEXTURE
		sprite.hframes = 4
		sprite.frame = 0
		$sprite/GPUParticles2D.emitting = false
		$sprite/HitOther/CollisionShape2D.disabled = true
	else:
		anim.play("idle")

func dash():
	if (Input.is_action_just_pressed("ui_dash")):
		buffer.addKey(("dash"))
	if ($dashTimer.is_stopped()):
		if (buffer.validFirst("dash")):
			buffer.eraseKey("dash")
			velocity+= speedDash * direction
			$dashTimer.start()
			currentDash=true
			playSound("audioDash",1,1.1)
			if abs(velocity.x)>LIMIT*0.1:
					anim.play("dash_lateral")		
			else:
				if velocity.y<0:
					anim.play("dash_up")
				else:
					anim.play("dash_down")
			
func is_attack_playing() -> bool:
	return anim.is_playing() and (anim.current_animation == "attack" or anim.current_animation == "atack_up" or anim.current_animation == "attack_down")

func finish_attack_lock() -> void:
	attackLock=0.0
	blockMove=false
	$sprite/HitOther/CollisionShape2D.disabled = true

func attack():
	if (Input.is_action_just_pressed("ui_action")):
		buffer.addKey(("attack"))
	if (not is_attack_playing()):
		if (buffer.validFirst("attack")):
			buffer.eraseKey("attack")
			var attack_direction:Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
			if attack_direction.length() < 0.2:
				attack_direction = ultimeDirection
			if abs(attack_direction.y) > abs(attack_direction.x) and abs(attack_direction.y) > 0.2:
				if attack_direction.y < 0:
					anim.play("atack_up")
				else:
					anim.play("attack_down")
			else:
				anim.play("attack")
			blockMove=true
			attackLock=ATTACK_LOCK_TIME
			currentDash=false
			playSound("audioAttack",1.2,1.2)
	
func reset():
	enableControl=false
	anim.play("reset")
	direction=Vector2.ZERO

func start():
	pass

func attempt_correction(amount: int):
	var delta = get_physics_process_delta_time()

	var directions = [
		Vector2(0, -1),  # Arriba
		Vector2(0, 1),   # Abajo
		Vector2(-1, 0),  # Izquierda
		Vector2(1, 0)    # Derecha
	]
	# Iterar sobre las direcciones
	for dir in directions:
		if velocity.dot(dir) < 0 and test_move(global_transform, dir * velocity.length() * delta):
			for i in range(1, amount * 2 + 1):
				for j in [-1.0, 1.0]:
					var offset = dir.orthogonal() * (i * j / 2) # Ortogonal a la dirección actual
					if !test_move(global_transform.translated(offset), dir * velocity.length() * delta):
						translate(offset)
						if velocity.dot(dir) * j < 0:
							velocity = velocity.slide(offset.normalized())
						return


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match  anim_name:
		"dash_up","dash_down","dash_lateral":
			currentDash=false
		"attack","atack_up","attack_down":
			finish_attack_lock()
func onHitDamage(forceHit:bool,damage:float):
	if((not inmortal or forceHit) and  enableControl):
		var music:AudioStreamPlayer= get_tree().get_first_node_in_group("music")
		music.pitch_scale+=0.1
		inmorTimer.start()
		inmortal=true
		attackExtra=0
		attackBar.empty()
		if(health>0):
			playSoundRandom(["audioHit","audioHit2"],1,1.1)

		else:
			playSoundRandom(["audioHit","audioHit2"],0.7,0.8)
			anim.play("death")
			music.stop()
			$sprite/GPUParticles2D.emitting=false
			General.on_player_killed_by_cerberus()
			General.createTimer(2,resetGame)
		General.shakeCamera(2, 1)
		animEffects.play("hit")
	
		#General.showEffectGlitch(true)
		var timer = get_tree().create_timer(0.05)
		var TWEN = get_tree().create_tween()
		TWEN.set_trans(Tween.TRANS_CUBIC)
		TWEN.set_ease(Tween.EASE_IN_OUT)
		TWEN.tween_property(Engine, "time_scale", 0.1, 0.05)
		TWEN.tween_property(self,"modulate", Color(1, 1, 1,0.5),0.2)
		timer.connect("timeout", _finishGlish);
	
func resetGame():
	get_tree().reload_current_scene()

func _finishGlish():
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property(Engine, "time_scale", 1, 0.05)
	animEffects.play("normal")
	#if(health==0):
	#	get_tree().reload_current_scene()

func death():
	pass


func endInmortailidad() -> void:
	inmortal=false
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property(self,"modulate", Color(1, 1, 1,1),0.2)
