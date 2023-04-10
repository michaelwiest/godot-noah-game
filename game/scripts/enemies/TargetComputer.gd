"""
Component to compute the next direction that an enemy should move in provided
some target (usually player) and avoids (other enemies?) via TargetDetectors.

This (and TargetDetector) should be extended to handle multiple targets.
"""
extends Node2D

@onready var target_detector: Area2D = $TargetDetector
@onready var avoid_detector: Area2D = $AvoidDetector

@onready var best_vector: Vector2
@onready var target_position: Vector2
@onready var avoid_position: Vector2
@onready var returned_position: Vector2
@onready var target_weight: float = 0.0
@onready var avoid_weight: float = 0.0
# How much to weight the target vs the avoid.
@export var bravery: float = 0.51
@onready var has_target: bool = false
@onready var has_avoid: bool = false


@onready var candidate_vectors: Array
@export var n_candidates: int = 4
@onready var target_scores: PackedFloat32Array
@onready var avoid_scores: PackedFloat32Array
@export var debug_widget: bool = true

func make_candidate_vectors():
	var rads_per_vec: float = (2 * PI) / n_candidates
	# For some reason this won't let me say that candidate vector is of Vector2
	candidate_vectors = range(0, n_candidates).map(func(i): return Vector2.RIGHT.rotated(i * rads_per_vec))

func zero_avoid_weights():
	avoid_scores = range(0, n_candidates).map(func(_foo): return 0.0)
	
func zero_target_weights():
	target_scores = range(0, n_candidates).map(func(_foo): return 0.0)
	

func set_ignored_body(body: CharacterBody2D):
	target_detector.ignored_body = body
	avoid_detector.ignored_body = body


func _ready():
	make_candidate_vectors()
	zero_target_weights()
	zero_avoid_weights()
	assert(0 <= bravery and bravery <= 1)


func _draw():
	for i in range(n_candidates):
		var cv = candidate_vectors[i]
		draw_line(cv * 15, cv * 20,  Color(255, 0, 0, max(avoid_scores[i], 0)), 5)
		draw_line(cv * 15, cv * 30,  Color(0, 255, 0, max(target_scores[i], 0)), 3)
	draw_line(best_vector * 15, best_vector * 40 * best_vector.length(), Color.BLUE, 2)
	draw_circle(returned_position, 5, Color.BLUE)
	
func get_neighbor_indices(index: int):
	var index_right: int = index + 1
	var index_left: int = index - 1
	if index_right >= n_candidates:
		index_right = 0
	if 	index_left < 0:
		index_left = -1
	return [index_left, index_right]
	

func compute_target(body_position: Vector2):
	"""Computes the optimal path among n_candidate vector options via dot prod.
	
	This computes the dot product between all candidates and the target and
	avoid locations. It then subtracts the avoid vector candidates from the 
	attact vector candidates and weights the options by distance.
	
	The vector with the highest score is then selected and an offset position
	is returned. An improvement would be to just have this return a direction
	and have the parent Enemy figure out the specific location. 
	"""
	
	# Each of these should likely be its own function call when switching to 
	# potentially multiple targets / avoids.
	has_target = target_detector.has_target()
	if has_target:
		target_position = target_detector.target.global_position
		var target_vector = body_position.direction_to(target_position)	
		target_scores = candidate_vectors.map(func vdot(cv): return cv.dot(target_vector))
		target_weight = 1.0 / body_position.distance_to(target_position)
	else: 
		target_weight = 0
		zero_target_weights()
	
	has_avoid = avoid_detector.has_target()
	if avoid_detector.has_target():
		avoid_position = avoid_detector.target.global_position
		var avoid_vector = body_position.direction_to(avoid_position)
		avoid_scores = candidate_vectors.map(func vdot(cv): return cv.dot(avoid_vector))
		# There is probably a better value in here like a sqrt or some
		# other function to apply.
		avoid_weight = 1.0 / body_position.distance_to(avoid_position)
	else:
		avoid_weight = 0
		zero_avoid_weights()
	
	if not has_target and not has_avoid:
		return body_position
	# Kind of a hack so that the enemies don't just run away if you're behind
	# an obstacle. 
	target_weight = max(target_weight, avoid_weight)
	var combined_scores: Array = range(n_candidates).map(func(i): return bravery * target_weight * target_scores[i] - ((1 - bravery) * avoid_weight * avoid_scores[i]))
	var best_index: int = combined_scores.find(combined_scores.max())
	# TODO (michaelwiest): Find neighboring candidates. And form a weighted average
	# among them to interpolate between candidates. 
	var neighbor_indices: Array = get_neighbor_indices(best_index)
	var left_index = neighbor_indices[0]
	var right_index = neighbor_indices[1]
	var weighted_vector = (
		candidate_vectors[best_index] * combined_scores[best_index] + 
		candidate_vectors[left_index] * combined_scores[left_index] + 
		candidate_vectors[right_index] * combined_scores[right_index]) / (combined_scores[best_index] + combined_scores[left_index] + combined_scores[right_index])
#
	best_vector = candidate_vectors[best_index].normalized()
	best_vector = weighted_vector.normalized()
	returned_position =  body_position + best_vector * 50
	if debug_widget:
		queue_redraw()
	return returned_position
#	
		
