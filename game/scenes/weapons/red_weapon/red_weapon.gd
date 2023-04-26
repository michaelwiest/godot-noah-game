extends Weapon
@onready var attack1 = $attack1

func use():
	attack1.use()

func _ready():
	print(len(attacks))
	print(weapon_data.damage, " ", weapon_data.force)

# This should instead be dynamically constructed from the array of attacks.
func _on_attack_1_attack_apply_hit_signal(entity):
	apply_damage(entity)
	apply_knockback(entity)
