extends Node2D
class_name Weapon

@export var weapon_data: WeaponData
@export var attacks: Array[Attack] = []
@onready var active_attack_index: int = 0

func _ready():
	print(len(attacks))
	assert(len(attacks) >= 0)
	

func use():
	attacks[active_attack_index].use()


func equip(equipment_slot):
	pass


#
func apply_damage(entity: Entity):
	entity.stats.hurt_amount(weapon_data.damage)


func apply_knockback(entity: Entity):
	entity.apply_knockback(position, weapon_data.force)
