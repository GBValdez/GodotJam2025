extends Entity
var direction:Vector2=Vector2.ZERO


func _physics_process(delta: float) -> void:
	# Detectar entrada del jugador
	direction = Vector2.ZERO
	direction.x= validateX($left,1)-validateX($right,-1)
	direction.y= validateY($down,-1)-validateY($up,1)
	if direction!=Vector2.ZERO:
		velocity.y -= SPEED*direction.y
		velocity.x += SPEED*direction.x

		
			
	apply_inertia(delta,direction)
	apply_limit(delta) 
	move_and_slide()
	if velocity!= Vector2.ZERO:
		General.applyPitchScale($audio,1,1.2)
		
func validRaycast(raycast:RayCast2D)->Vector2:
	if not raycast.is_colliding():
		return Vector2.ZERO
	var body:Node2D= raycast.get_collider()
	if not body.is_in_group("player"):
		return Vector2.ZERO	
	return body.previousVelocity

func validateX(raycast:RayCast2D,deseable:int)->int:
	var vel= validRaycast(raycast)
	print(vel)
	if sign(vel.x)!= deseable:
		return 0
	return 1
	

func validateY(raycast:RayCast2D,deseable:int)->int:
	var vel= validRaycast(raycast)
	if sign(vel.y)!= deseable:
		return 0
	return 1	
	
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
