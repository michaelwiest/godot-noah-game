extends Control

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot

var grabbed_slot_data: SlotData

func _physics_process(delta: float) -> void:
	# When an item has been 'grabbed' have it track the mouse
	if grabbed_slot.visible:
		grabbed_slot.size = grabbed_slot.size * .5
		grabbed_slot.global_position = get_global_mouse_position()

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func on_inventory_interact(
	inventory_data: InventoryData, node_index: int, button_index: int
) -> void:
	print("%s %s %s" % [inventory_data, node_index, button_index])
	
	match [grabbed_slot_data, button_index]:
		# Grab Item
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(node_index)
		# Drop Item
		[_, MOUSE_BUTTON_LEFT]:
			print("attempting to drop grabbed_slot_data: %s Node idx: %s" % [grabbed_slot_data, node_index])
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, node_index)
			print("new slot data: %s" % grabbed_slot_data)
		# Use Item
		[null, MOUSE_BUTTON_RIGHT]:
			pass
		# Drop one item
		[_, MOUSE_BUTTON_RIGHT]:
			print("attempting to drop slot_data: %s Node idx: %s" % [grabbed_slot_data, node_index])
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, node_index)
			print("duplicated slot data: %s" % grabbed_slot_data)
	
	update_grabbed_slot()
	
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
		
