"""
Component to compute the next direction that an enemy should move in provided
some target (usually player) and repels (other enemies?) via TargetDetectors.

This (and TargetDetector) should be extended to handle multiple targets.
"""
extends Node2D

@onready var attract_detector: Area2D = $TargetDetector
@onready var repel_detector: Area2D = $AvoidDetector

@onready var best_vector: Vector2
@onready var attract_position: Vector2
@onready var repel_position: Vector2
@onready var attract_weight: float = 0.0
@onready var repel_weight: float = 0.0
# How much to weight the target vs the avoid.
@export var bravery: float = 0.4
@onready var has_attract: bool = false
@onready var has_repel: bool = false


@onready var candidate_vectors: Array
@export var n_candidates: int = 4
@onready var attract_scores: PackedFloat32Array
@onready var repel_scores: PackedFloat32Array
@export var debug_widget: bool = true

func make_candidate_vectors():
	var rads_per_vec: float = (2 * PI) / n_candidates
	# For some reason this won't let me say that candidate vector is of Vector2
	candidate_vectors = range(0, n_candidates).map(func(i): return Vector2.RIGHT.rotated(i * rads_per_vec))

func zero_repel_weights():
	repel_scores = range(0, n_candidates).map(func(_foo): return 0.0)
	
func zero_attract_weights():
	attract_scores = range(0, n_candidates).map(func(_foo): return 0.0)
	

func set_ignored_body(body: CharacterBody2D):
	attract_detector.ignored_body = body
	repel_detector.ignored_body = body


func _ready():
	make_candidate_vectors()
	zero_attract_weights()
	zero_repel_weights()
	assert(0 <= bravery and bravery <= 1)
	# Causes a divide by zero if something is a repeller and attractor
	if bravery == 0.5:
		bravery += 0.001


func _draw():
	for i in range(n_candidates):
		var cv = candidate_vectors[i]
		draw_line(cv * 15, cv * 20,  Color(255, 0, 0, max(repel_scores[i], 0)), 5)
		draw_line(cv * 15, cv * 30,  Color(0, 255, 0, max(attract_scores[i], 0)), 3)
	draw_line(best_vector * 15, best_vector * 40 * best_vector.length(), Color.BLUE, 2)
	
func get_neighbor_indices(index: int):
	var index_right: int = index + 1
	var index_left: int = index - 1
	if index_right >= n_candidates:
		index_right = 0
	if 	index_left < 0:
		index_left = -1
	return [index_left, index_right]
	
func blend_candidate_vectors(best_index: int, combined_scores: Array): 
	"""Takes a weighted average of the best vector and its neighbors."""
	var neighbor_indices: Array = get_neighbor_indices(best_index)
	var left_index = neighbor_indices[0]
	var right_index = neighbor_indices[1]
	var weighted_vector = (
		candidate_vectors[best_index] * combined_scores[best_index] + 
		candidate_vectors[left_index] * combined_scores[left_index] + 
		candidate_vectors[right_index] * combined_scores[right_index]) / (combined_scores[best_index] + combined_scores[left_index] + combined_scores[right_index])
	weighted_vector = weighted_vector.rotated(randf_range(0, PI / 10))
	return weighted_vector
	
func shape_weight_vectors(attract_scores: PackedFloat32Array, repel_scores: PackedFloat32Array) -> Array:
	"""Shapes and combines the attract / repel vectors to find optimal."""
	# Kind of a hack so that the enemies don't just run away if you're behind
	# an obstacle. 
	attract_weight = max(attract_weight, repel_weight)
	var shaped_weights: Array = range(n_candidates).map(func(i): return bravery * attract_weight * attract_scores[i] - ((1 - bravery) * repel_weight * repel_scores[i]))
	return shaped_weights

func compute_target_direction(body_position: Vector2):
	"""Computes the optimal path among n_candidate vector options via dot prod.
	
	This computes the dot product between all candidates and the target and
	avoid locations. It then subtracts the avoid vector candidates from the 
	attact vector candidates and weights the options by distance.
	
	The vector with the highest score is then selected and an offset position
	is returned. An improvement would be to just have this return a direction
	and have the parent Enemy figure out the specific location. 
	"""
	
	# TODO (michaelwiest): Each of these should likely be its own function call 
	# when switching to potentially multiple targets / avoids.
	has_attract = attract_detector.has_target()
	if has_attract:
		attract_position = attract_detector.target.global_position
		var attract_vector = body_position.direction_to(attract_position)	
		attract_scores = candidate_vectors.map(func vdot(cv): return cv.dot(attract_vector))
		attract_weight = 1.0 / body_position.distance_to(attract_position)
	else: 
		attract_weight = 0
		zero_attract_weights()
	
	has_repel = repel_detector.has_target()
	if repel_detector.has_target():
		repel_position = repel_detector.target.global_position
		var repel_vector = body_position.direction_to(repel_position)
		repel_scores = candidate_vectors.map(func vdot(cv): return cv.dot(repel_vector))
		# There is probably a better value in here like a sqrt or some
		# other function to apply.
		repel_weight = 1.0 / body_position.distance_to(repel_position)
	else:
		repel_weight = 0
		zero_repel_weights()
	if not has_attract and not has_repel:
		return Vector2.ZERO
	var combined_scores: Array = shape_weight_vectors(attract_scores, repel_scores)
	var best_index: int = combined_scores.find(combined_scores.max())
	best_vector = blend_candidate_vectors(best_index, combined_scores).normalized()
	if debug_widget:
		queue_redraw()
	return best_vector
#	
		
