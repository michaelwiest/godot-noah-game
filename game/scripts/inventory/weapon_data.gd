extends ItemData
class_name WeaponData

enum EquipmentSlot {
	LIGHT,
	HEAVY,
	PROJECTILE
}

@export var force: float
@export var damage: float
@export var stops_movment: bool 
@export var equipment_slot: EquipmentSlot
