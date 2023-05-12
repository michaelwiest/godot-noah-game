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
@export var attack_indices: Array[int]
@export var attack_scenes: Array[PackedScene] = []
@export var combo_window: float = 0.2  # Seconds

func _ready():
	assert (attack_indices.max() < len(attack_scenes))
