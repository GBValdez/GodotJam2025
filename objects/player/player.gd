extends Entity
class_name  Player
@export_category("Controls")
@export var enableControl:bool=true
var direction:Vector2= Vector2.ZERO

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
	move_and_slide()
	

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
