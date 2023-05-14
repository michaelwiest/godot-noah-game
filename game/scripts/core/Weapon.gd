extends Node2D
class_name Weapon

@export var weapon_data: WeaponData
@onready var active_attack_index: int = 0
@onready var attacks: Array[Attack]
@onready var attacking: bool = false
@onready var combo_timer = $ComboTimer

		
func _increment_attack_index():
	active_attack_index = (active_attack_index + 1) % len(attacks)

func _create_attacks():
	# Helper function to attach attacks to a weapon given 
	# the supplied packed scenes
	if not weapon_data:
		return
		
	for attack_index in weapon_data.attack_indices:
		var attack: Attack = weapon_data.attack_scenes[attack_index].instantiate()
		add_child(attack)
		attack.attack_apply_hit_signal.connect(apply_hit)
		attack.attack_end_signal.connect(attack_end)
		attack.attack_start_signal.connect(attack_start)
		attack.disable()
		attacks.append(attack)


func _ready():
	_create_attacks()
	
	
func flip_h():
	# Horizontally flip the whole weapon.
	scale = Vector2(scale[0] * -1, 1)
	
func use():
	# Check if not attacking and attack index is not out of bounds
	# Gaurd against attacks of size 0 
	if not attacking and active_attack_index < len(attacks):
		attacks[active_attack_index].use()
		_increment_attack_index()


func equip(equipment_slot):
	pass

func apply_hit(entity: Entity):
	apply_damage(entity)
	apply_knockback(entity)
	
	
func apply_damage(entity: Entity):
	entity.stats.hurt_amount(weapon_data.damage)


func apply_knockback(entity: Entity):
	entity.apply_knockback(position, weapon_data.force)

func attack_start():
	attacking = true

func attack_end():
	attacking = false
	combo_timer.start(weapon_data.combo_window)
	


func _on_combo_timer_timeout():
	if !attacking:
		active_attack_index = 0
