extends Node2D

@export var direction: Vector2 = Vector2.RIGHT
@export var bounce_count: int = 20
@export var warning_time: float = 1.0
@export var laser_width_warning: float = 1
@export var laser_width_active: float = 5

@onready var line: Line2D = $Line2D
@onready var timer: Timer = $Timer

var is_active: bool = false

func _ready() -> void:
	line.width = laser_width_warning
	timer.wait_time = warning_time
	timer.one_shot = true
	timer.start()
	var origin = position  # o global_position si ya estás seguro que fue asignado
	calculate_and_draw_trajectory()

func calculate_bounce_path(origin: Vector2, dir: Vector2, bounces: int) -> Array[Vector2]:
	var result: Array[Vector2] = [origin]
	var current_pos: Vector2 = origin
	var current_dir: Vector2 = dir.normalized()
	var space_state = get_world_2d().direct_space_state

	for i in bounces:
		var to = current_pos + current_dir * 6000  # largo del rayo
		var ray_params = PhysicsRayQueryParameters2D.create(current_pos, to)
		ray_params.exclude = [self]
		ray_params.collision_mask = 1 << 3  # Asegúrate de que el target esté en esta capa

		var collision = space_state.intersect_ray(ray_params)
		
		if collision:
			var collision_point = collision.position
			var collider = collision.collider

			# ✅ Aplicar daño si el láser ya está activo
			if is_active and collider and collider.has_method("apply_damage"):
				collider.apply_damage(10)  # Puedes cambiar el valor de daño

			result.append(collision_point)
			current_pos = collision_point
			current_dir = current_dir.bounce(collision.normal)
		else:
			result.append(to)
			break

	return result

func _on_timer_timeout() -> void:
	is_active = true
	line.width = laser_width_active

func calculate_and_draw_trajectory():
	await get_tree().process_frame 
	var origin = global_position  
	var trajectory = calculate_bounce_path(origin, direction, bounce_count)
	line.clear_points()
	for point in trajectory:
		line.add_point(to_local(point))  

func _on_delete_timeout() -> void:
	queue_free()
