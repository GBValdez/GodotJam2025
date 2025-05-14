extends Entity
class_name  Player
@export_category("Controls")
@export var enableControl:bool=true
@export var speedDash: float = 10000;
var previousVelocity:Vector2=Vector2.ZERO
var buffer : bufferPlayer= bufferPlayer.new()
var currentDash:bool= false

@export var blockMove:bool=false;
func _ready() -> void:
	$AnimationPlayer.play("idle")
	

func _physics_process(delta: float) -> void:
	buffer.update(delta)
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
			General.spriteShadow($Sprite2D,0.2,currentColor)
			General.shakeCameraDir(0.5,0.1,velocity.normalized())
		else:	
			if abs(velocity.x)>LIMIT*0.1:
				$AnimationPlayer.play("walk")
			else:
				if velocity.y<0:
					$AnimationPlayer.play("walk_up")
				else:
					$AnimationPlayer.play("walk_down")
		General.applyPitchScale($audioStep,0.8,1)
	else:
		if not currentDash:
			$AnimationPlayer.play("idle")

	if velocity.x!=0:
		$Sprite2D.scale.x= sign(velocity.x) * abs($Sprite2D.scale.x) 

func apply_inertia(delta: float,direction:Vector2) -> void:
	var velNormalize=velocity.normalized()		
		
	if velocity.x != 0 and direction.x==0:
		var SIGN= sign(velNormalize.x)
		velocity.x -= INERTIA * velNormalize.x * delta
		if sign(velocity.x)!= SIGN:
			velocity.x=0

	if velocity.y !=0 and direction.y==0:
		var SIGN= sign(velNormalize.y)
		velocity.y -= INERTIA * velNormalize.y * delta
		if sign(velocity.y)!= SIGN:
			velocity.y=0

func dash():
	if (Input.is_action_just_pressed("ui_dash")):
		buffer.addKey(("dash"))
	if ($dashTimer.is_stopped()):
		if (buffer.validFirst("dash")):
			buffer.eraseKey("dash")
			velocity+= speedDash * direction
			$dashTimer.start()
			currentDash=true
			if abs(velocity.x)>LIMIT*0.1:
					$AnimationPlayer.play("dash_lateral")		
			else:
				if velocity.y<0:
					$AnimationPlayer.play("dash_up")
				else:
					$AnimationPlayer.play("dash_down")
			
func attack():
	if (Input.is_action_just_pressed("ui_action")):
		buffer.addKey(("attack"))
	if (not $AnimationPlayer.current_animation=="attack"):
		if (buffer.validFirst("attack")):
			buffer.eraseKey("attack")
			if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
				$AnimationPlayer.play("attack")
			elif Input.is_action_pressed("ui_up"):
				$AnimationPlayer.play("atack_up")
			elif Input.is_action_pressed("ui_down"):
					$AnimationPlayer.play("attack_down")
			else:
				$AnimationPlayer.play("attack")
			blockMove=true
			currentDash=false
	
func reset():
	enableControl=false
	$AnimationPlayer.play("reset")
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
	print("haaa")
	match  anim_name:
		"dash_up","dash_down","dash_lateral":
			currentDash=false
			print("hola")
