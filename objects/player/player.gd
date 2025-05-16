extends Entity
class_name  Player
@export_category("Controls")
@export var enableControl:bool=true
@export var speedDash: float = 10000;
var previousVelocity:Vector2=Vector2.ZERO
var buffer : bufferPlayer= bufferPlayer.new()
var currentDash:bool= false
@onready var inmorTimer:Timer= $inmortalidad

@export var blockMove:bool=false;
func _ready() -> void:
	anim.play("idle")
	#General.shakeCamera(5, 10)

	

func _physics_process(delta: float) -> void:
	buffer.update(delta)
	print(INERTIA)
	# Detectar entrada del jugador
	if (enableControl):
		direction = Vector2.ZERO
		if (not blockMove):
			direction.x = Input.get_axis("ui_left", "ui_right")
			direction.y = Input.get_axis("ui_up", "ui_down")
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
			anim.play("idle")

	if velocity.x!=0:
		sprite.scale.x= sign(velocity.x) * abs(sprite.scale.x) 



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
			
func attack():
	if (Input.is_action_just_pressed("ui_action")):
		buffer.addKey(("attack"))
	if (not anim.current_animation=="attack"):
		if (buffer.validFirst("attack")):
			buffer.eraseKey("attack")
			if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
				anim.play("attack")
			elif Input.is_action_pressed("ui_up"):
				anim.play("atack_up")
			elif Input.is_action_pressed("ui_down"):
					anim.play("attack_down")
			else:
				anim.play("attack")
			blockMove=true
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
func onHitDamage(forceHit:bool):
	if((not inmortal or forceHit) and  enableControl):
		inmorTimer.start()
		inmortal=true
		if(health>0):
			playSoundRandom(["audioHit","audioHit2"],1,1.1)

		else:
			playSoundRandom(["audioHit","audioHit2"],0.7,0.8)
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
	
	

func _finishGlish():
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property(Engine, "time_scale", 1, 0.05)
	animEffects.play("normal")
	if(health==0):
		get_tree().reload_current_scene()

func death():
	pass


func endInmortailidad() -> void:
	inmortal=false
	var TWEN = get_tree().create_tween()
	TWEN.set_trans(Tween.TRANS_CUBIC)
	TWEN.set_ease(Tween.EASE_IN_OUT)
	TWEN.tween_property(self,"modulate", Color(1, 1, 1,1),0.2)
