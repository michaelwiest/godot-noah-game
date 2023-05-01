extends Node2D
class_name Weapon

@export var weapon_data: WeaponData
@export var attack_paths: Array[String]
@onready var active_attack_index: int = 0
@onready var attacks: Array[Attack]
@onready var attacking: bool = false

func _get_attack_path(attack_path: String) -> String:
	# If it is an absolute path then assume it's fine.
	var to_return: String
	if len(attack_path.split('/')) > 1: 
		to_return = attack_path
	else:
		var base_path: String = self.scene_file_path
		base_path = base_path.rsplit("/", true, 1)[0]
		to_return = base_path + "/" + attack_path
	if to_return.ends_with(".tscn"):
		return to_return
	else:
		return to_return + ".tscn"
		
func _increment_attack_index():
	active_attack_index = (active_attack_index + 1) % len(attacks)
	
func _create_attacks():
	for ap in attack_paths:
		var attack: Attack = load(_get_attack_path(ap)).instantiate()
		add_child(attack)
		attack.attack_end()
		attack.attack_apply_hit_signal.connect(apply_hit)
		attack.attack_end_signal.connect(attack_end)
		attack.attack_start_signal.connect(attack_start)
		attacks.append(attack)


func _ready():
	# Helper function to attach attacks to a weapon given 
	# the supplied paths.
	_create_attacks()

	
func flip_h():
	# Horizontally flip the whole weapon.
	scale = Vector2(scale[0] * -1, 1)
	
func use():
	if not attacking:
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
