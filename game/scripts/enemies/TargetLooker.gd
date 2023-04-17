"""Class for checking that an entity can see the player unobstructed.

This will be useful for checking whether or not an enemy should attack the 
player with either a melee attack or a projectile.
"""
extends Node2D

@export var length: int = 100
@export var angle_window_degrees: int = 30
@export var n_rays: int = 5
@export var enabled: bool = true
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var ray_coordinates: Array[Vector2]
# This isn't typed so it can be nullable. 
@onready var target


func _ready():
	ray_cast.target_position = Vector2(length, 0)
	_precompute_ray_angles()

func can_see_player():
	return target is Player

func _precompute_ray_angles():
	# Precomputes the raycasts for efficiency.
	var ray_degrees: float = deg_to_rad(angle_window_degrees / n_rays)
	var start_angle: float = -1 * deg_to_rad(angle_window_degrees / 2)
	for i in n_rays:
		var cast_vector: Vector2 = length * Vector2.RIGHT.rotated(start_angle + (i * ray_degrees))
		ray_coordinates.append(cast_vector)

func check_for_target(delta):
	if enabled:
		for ray_i in ray_coordinates:
			ray_cast.target_position = ray_i
			ray_cast.force_raycast_update()
			if ray_cast.is_colliding():
				target = ray_cast.get_collider()
				break
			target = null

func _physics_process(delta):
	check_for_target(delta)
