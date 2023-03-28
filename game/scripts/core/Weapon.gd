extends Node
class_name Weapon

@export var knockback: float
@export var damage: float
@export var stops_movment: bool 
# Need something here to denote when you can equip it. 
@export var equipable_slots: int
@onready var held_sprite: Sprite2D = $HeldSprite
@onready var use_sprite: Sprite2D = $UseSprite
@onready var UseAnimation: AnimationPlayer = $UseAnimation
@onready var held_hitbox: HitBox = $HeldHitbox
@onready var use_hitbox: HitBox = $Marker2D/UseHitbox
var movement_stopped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	use_sprite.visible = false
	use_hitbox.disable()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#
#func use():
#	UseAnimation.play("use")
#

func equip(equipment_slot):
	pass

func use_animation_started():
	if stops_movment:
		movement_stopped = true
	held_sprite.visible = false
	use_sprite.visible = true
	held_hitbox.disable()
	use_hitbox.enable()
	


func use_animation_finished():
	if stops_movment:
		movement_stopped = false
	use_sprite.visible = false
	held_sprite.visible = true
	held_hitbox.enable()
	use_hitbox.disable()

