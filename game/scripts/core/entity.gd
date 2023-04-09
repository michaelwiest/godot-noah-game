extends CharacterBody2D
class_name Entity

@export var stats: Stats
@export var mass: float = 1.0
@export var max_speed: float = 10.0
@export var friction: float = 5.0
@export var acceleration: float = 5.0

@export var effect_player: AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var direction: Vector2 = Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("showing shader")
	sprite.material.set_shader_parameter("show", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_stats_no_health():
	queue_free()


func _on_hurtbox_area_entered(area: HitBox):
	area.apply_damage(self)
	area.apply_knockback(self)
	effect_player.play("hit")
	
	
#	velocity += compute_knockback(area)


func compute_knockback(weapon: Weapon):
	var knockback_direction: Vector2 = weapon.global_position.direction_to(global_position)
	var knockback_force: Vector2 = knockback_direction * weapon.force / mass
	return knockback_force

func apply_knockback(weapon: Weapon):
	velocity += compute_knockback(weapon)
	

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, 0, friction)
	velocity.y = move_toward(velocity.y, 0, friction)
	move_and_slide()
