extends Node2D

@onready var target_detector: Area2D = $TargetDetector
@onready var avoid_detector: Area2D = $AvoidDetector

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func compute_target(body_position: Vector2):
#	print(target_detector.has_target())
	var target_vector = null
	var avoid_vector = null
	var target_position = null
	var avoid_position = null
	if target_detector.has_target():
		target_position = target_detector.target.global_position
		target_vector = body_position.direction_to(target_position)	
	if avoid_detector.has_target():
		avoid_position = avoid_detector.target.global_position
		avoid_vector = body_position.direction_to(avoid_position)
	if target_vector != null and avoid_vector != null:
		print("DOT: ", target_vector.dot(avoid_vector))
#		print("CROSS: ", avoid_vector.cross(target_vector))
		print("NORMAL: ", target_vector.direction_to(avoid_position))
		return target_position
