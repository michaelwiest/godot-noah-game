extends Node2D

@onready var target_detector: Area2D = $TargetDetector
@onready var avoid_detector: Area2D = $AvoidDetector

@onready var target_vector: Vector2
@onready var avoid_vector: Vector2
@onready var best_vector: Vector2
@onready var target_position: Vector2
@onready var avoid_position: Vector2
@onready var returned_position: Vector2
@onready var target_avoid_angle: float
@onready var target_weight: float = 0.0
@onready var avoid_weight: float = 0.0
# How much to weight the target vs the avoid.
@export var bravery: float = 0.51
@onready var has_target: bool = false
@onready var has_avoid: bool = false


@onready var candidate_vectors: Array
@export var n_candidates: int = 12
@onready var target_scores: PackedFloat32Array
@onready var avoid_scores: PackedFloat32Array


func make_candidate_vectors():
	var rads_per_vec: float = (2 * PI) / n_candidates
	# For some reason this won't let me say that candidate vector is of Vector2
	candidate_vectors = range(0, n_candidates).map(func(i): return Vector2.RIGHT.rotated(i * rads_per_vec))

func zero_avoid_weights():
	avoid_scores = range(0, n_candidates).map(func(_foo): return 0.0)
func zero_target_weights():
	target_scores = range(0, n_candidates).map(func(_foo): return 0.0)
	

func _ready():
	make_candidate_vectors()
	zero_target_weights()
	zero_avoid_weights()
	assert(0 <= bravery and bravery <= 1)


func _draw():
	for i in range(n_candidates):
		draw_line(Vector2.ZERO, candidate_vectors[i] * 25,  Color(255, 0, 0, abs(avoid_scores[i])), 4)
		draw_line(Vector2.ZERO, candidate_vectors[i] * 40,  Color(0, 255, 0, abs(target_scores[i])), 2)
	draw_line(Vector2.ZERO, best_vector * 50, Color.BLUE, 3)
	

func compute_target(body_position: Vector2):
	has_target = target_detector.has_target()
	if has_target:
		target_position = target_detector.target.global_position
		target_vector = body_position.direction_to(target_position)	
		target_scores = candidate_vectors.map(func vdot(cv): return cv.dot(target_vector))
		target_weight = 1.0 / body_position.distance_to(target_position)
	else: 
		target_weight = 0
		zero_target_weights()
	
	has_avoid = avoid_detector.has_target()
	if avoid_detector.has_target():
		avoid_position = avoid_detector.target.global_position
		avoid_vector = body_position.direction_to(avoid_position)
		avoid_scores = candidate_vectors.map(func vdot(cv): return cv.dot(avoid_vector))
		avoid_weight = 1.0 / body_position.distance_to(avoid_position)
	else:
		avoid_weight = 0
		zero_avoid_weights()
	
	if not has_target and not has_avoid:
		return body_position
	var combined_scores: Array = range(n_candidates).map(func(i): return bravery * target_weight * target_scores[i] - ((1 - bravery) * avoid_weight * avoid_scores[i]))
	var best_index: int = combined_scores.find(combined_scores.max())
	best_vector = candidate_vectors[best_index].normalized()
	returned_position =  body_position + best_vector * 10
	queue_redraw()
	return returned_position
#	
		
