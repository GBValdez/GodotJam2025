extends Entity
class_name  Player
@export_category("Controls")
@export var enableControl:bool=true
var direction:Vector2= Vector2.ZERO
func _ready() -> void:
	$AnimationPlayer.play("idle")
	

func _physics_process(delta: float) -> void:
	# Detectar entrada del jugador
	if (enableControl):
		direction = Vector2.ZERO
		direction.x = Input.get_axis("ui_left", "ui_right")
		direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()
	
	# Aplicar movimiento basado en entrada
	velocity += direction * SPEED*delta	
	apply_inertia(delta,direction)
	apply_limit(delta) 
	#attempt_correction(5)
	move_and_slide()
	animation()
	
func animation():
	if General.endGame:
		return
		
	if velocity.length() > 0:
		$AnimationPlayer.play("walk")
	else:
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


func reset():
	enableControl=false
	$AnimationPlayer.play("reset")
	direction=Vector2.ZERO

func start():
	pass

func attempt_correction(amount: int):
	var delta = get_physics_process_delta_time()

	# Direcciones a verificar: arriba, abajo, izquierda, derecha
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
