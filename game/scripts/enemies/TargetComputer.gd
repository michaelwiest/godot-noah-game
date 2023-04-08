extends Node2D

@onready var target_detector: Area2D = $TargetDetector
@onready var avoid_detector: Area2D = $AvoidDetector

@onready var target_vector: Vector2
@onready var avoid_vector: Vector2
@onready var final_vector: Vector2
@onready var target_position: Vector2
@onready var avoid_position: Vector2
@onready var returned_position: Vector2
@onready var target_avoid_angle: float
@export var avoidance_blend: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
#	set_process(true)
	pass

	

func _draw():
	draw_line(Vector2.ZERO, target_vector * 50, Color(0, 255, 0, 1), 2)
	draw_line(Vector2.ZERO, avoid_vector * 50, Color(255, 0, 0, 1), 2)
	draw_line(Vector2.ZERO, final_vector * 50, Color(0, 0, 255, 1), 2)
	draw_circle(target_position, 5, Color.GREEN)
	draw_circle(avoid_position, 5, Color.RED)
	draw_circle(returned_position, 5, Color.BLUE)
	


func compute_target(body_position: Vector2):
#	print(target_detector.has_target())
#	var target_vector = null
#	var avoid_vector = null
#	var target_position = null
#	var avoid_position = null
	if target_detector.has_target():
		target_position = target_detector.target.global_position
		target_vector = body_position.direction_to(target_position)	
#	else: 
#		target_position = null
	if avoid_detector.has_target():
		avoid_position = avoid_detector.target.global_position
		avoid_vector = body_position.direction_to(avoid_position)
#	else: 
#		target_position = null
	if target_vector != null and avoid_vector != null:
		var avoid_dot: float = target_vector.dot(avoid_vector)
		print("DOT: ", avoid_dot)
#		print("CROSS: ", avoid_vector.cross(target_vector))
		
		target_avoid_angle = rad_to_deg(avoid_vector.angle_to(target_vector))
#		print("ANGLE: ", target_avoid_angle)
		# Want to move perpendicular to the offending point.
		var perpendicular_angle = target_avoid_angle + sign(target_avoid_angle) * 90
#		print("perpendicular angle: ", perpendicular_angle)
		final_vector = avoid_vector.rotated(deg_to_rad(perpendicular_angle)).normalized()
#		print("perp vector: ", final_vector)
#		print("target vector: ", target_vector)
		# If it is behind the enemy then we don't care.
		if avoid_dot > 0:
			final_vector = (abs(avoid_dot) * avoidance_blend * final_vector + (1 - abs(avoid_dot)) * target_vector).normalized() * (1 - avoidance_blend)
		else:
			final_vector = target_vector
			
		queue_redraw()
#		print(PI)
#		print("NORMAL: ", target_vector.direction_to(avoid_position))
		returned_position = body_position + final_vector * 100
		return returned_position
		
