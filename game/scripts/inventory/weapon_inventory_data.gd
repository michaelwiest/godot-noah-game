extends InventoryData
class_name WeaponInventoryData


func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	# Attempt to cast grabbed_slot_data to WeaponData
	var is_weapon_data = grabbed_slot_data.item_data as WeaponData
	if not is_weapon_data is WeaponData:
		return grabbed_slot_data
		
	return super.drop_slot_data(grabbed_slot_data, index)

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	# Attempt to cast grabbed_slot_data to WeaponData
	var is_weapon_data = grabbed_slot_data.item_data as WeaponData
	if not is_weapon_data is WeaponData:
		return grabbed_slot_data
		
	return super.drop_single_slot_data(grabbed_slot_data, index)

func replace_slot_data(new_slot_data: SlotData, index: int) -> void:
	# Attempt to cast grabbed_slot_data to WeaponData
	var is_weapon_data = new_slot_data.item_data as WeaponData
	if not is_weapon_data is WeaponData:
		return
	
	super.replace_slot_data(new_slot_data, index)
