extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, node_index: int, button_index: int)

@export var slot_data_list: Array[SlotData]

func on_slot_clicked(node_index: int, button_index: int) -> void:
	inventory_interact.emit(self, node_index, button_index)

func grab_slot_data(index: int) -> SlotData:
	var slot_data = null
	if index >= 0 and index < len(slot_data_list):
		slot_data = slot_data_list[index]
		slot_data_list[index] = null
		inventory_updated.emit(self)
	return slot_data


func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data: SlotData = null
	
	# Make sure index is in range
	if index >= 0 and index < len(slot_data_list):
		# Attempt to stack grabbed item on current index slot
		slot_data = slot_data_list[index]
		if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
			# When we merge, the item is dropped and no new items are grabbed
			slot_data.fully_merge_with(grabbed_slot_data)
			slot_data = null
		else:		
			slot_data_list[index] = grabbed_slot_data
		inventory_updated.emit(self)
	return slot_data

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data: SlotData = null
	
	if index >= 0 and index < len(slot_data_list):
		slot_data = slot_data_list[index]
		# Dropping on a slot that is empty
		if not slot_data:
			slot_data_list[index] = grabbed_slot_data.create_single_slot_data()
		# Dropping on a non empty slot, check if it can be stacked
		elif slot_data.can_merge_with(grabbed_slot_data):
			slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
		
		inventory_updated.emit(self)
		
		if grabbed_slot_data.quantity > 0:
			return grabbed_slot_data
	return null

## Find first empty slot and add item unless item can be stacked, then stack it and return true
## If no empty slots are found, item will not be added and function returns false
func insert_slot_data(new_slot_data: SlotData) -> bool:
	## Search for stackable items and try to stack. 
	## If cannot stack attempt to add to new slot.
	if new_slot_data.item_data.stackable:
		for slot_data in slot_data_list:
			if slot_data:
				if slot_data and slot_data.can_fully_merge_with(new_slot_data):
					slot_data.fully_merge_with(new_slot_data)
					inventory_updated.emit(self)
					return true
	# Item was not stacked so add it to an empty slot
	for i in slot_data_list.size():
		if not slot_data_list[i]:
			slot_data_list[i] = new_slot_data
			inventory_updated.emit(self)
			return true
	return false

func replace_slot_data(new_slot_data: SlotData, index: int) -> void:
	if index >= 0 and index < len(slot_data_list):
		slot_data_list[index] = new_slot_data
		inventory_updated.emit(self)
		
			
