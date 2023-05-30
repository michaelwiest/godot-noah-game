extends Control

@onready var item_player_inventory: PanelContainer = $ItemPlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var weapon_player_inventory: PanelContainer = $WeaponPlayerInventory
@onready var equipment_player_inventory: PanelContainer = $EquipmentPlayerInventory

var grabbed_slot_data: SlotData

func _physics_process(delta: float) -> void:
	# When an item has been 'grabbed' have it track the mouse
	if grabbed_slot.visible:
		grabbed_slot.size = grabbed_slot.size * .5
		grabbed_slot.global_position = get_global_mouse_position()

func set_item_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	item_player_inventory.set_inventory_data(inventory_data)
	
func set_weapon_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	weapon_player_inventory.set_inventory_data(inventory_data)

func set_equipment_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	equipment_player_inventory.set_inventory_data(inventory_data)

func on_inventory_interact(
	inventory_data: InventoryData, node_index: int, button_index: int
) -> void:	
	match [grabbed_slot_data, button_index]:
		# Grab Item
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(node_index)
		# Drop Item
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, node_index)
		# Use Item
		[null, MOUSE_BUTTON_RIGHT]:
			pass
		# Drop one item
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, node_index)
	
	update_grabbed_slot()
	
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
		
