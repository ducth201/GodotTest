extends TextureRect

@onready var inventory = $GridContainer

var _lastDragSlotNode = null

func _ready():
	
	Messenger.connect("ITEM_PICKED_UP", pickup_item )
	
	for slot in inventory.get_children():
		if slot.item != null:
			slot.textureRect.texture = slot.item.texture

func add_item( item : ItemResource ) -> bool:
	# first try to find similar items already in inventory
	if item.max_stack_size > 1:
		for slot in inventory.get_children():
			if slot.item != null && !slot.is_full && item.name == slot.item.name:
				slot.add_item( item )
				return true
	
	for slot in inventory.get_children():
		if slot.item == null:
			slot.item = item
			slot.textureRect.texture = slot.item.texture
			return true
	return false
	

func pickup_item( pickup : Pickup ):
	if add_item( pickup.item ):
		pickup.queue_free()
	else:
		print( "inventory full" )

func _get_drag_data(at_position: Vector2) -> Variant:
	
	var dragSlotNode : ItemSlot = get_slot_node_at_position(at_position)
	_lastDragSlotNode = dragSlotNode
	
	if !dragSlotNode: return
	if dragSlotNode == null or dragSlotNode.item == null: return
	
	var dragPreviewNode = dragSlotNode.duplicate()
	dragSlotNode.textureRect.texture = null
	
	var c = Control.new()
	c.add_child(dragPreviewNode)
	
	# center drag preview
	dragPreviewNode.position = - dragSlotNode.get_rect().size/2
	
	set_drag_preview(c)
	return dragSlotNode

func _can_drop_data(at_position: Vector2, _data: Variant) -> bool:
	var targetSlotNode = get_slot_node_at_position(at_position)
	return targetSlotNode != null

func _drop_data(at_position: Vector2, dragSlotNode: Variant) -> void:
	
	var targetSlotNode = get_slot_node_at_position(at_position)
	if targetSlotNode == dragSlotNode:
		targetSlotNode.textureRect.texture = targetSlotNode.item.texture
		return
	
	var targetItem = targetSlotNode.item
	
	targetSlotNode.add_item( dragSlotNode.item )
	
	if targetItem == null:
		dragSlotNode.clear()
	else:
		dragSlotNode.add_item( targetItem )
		
	# debug inventory
	#for slot in inventory.get_children():
	#	if slot.item != null:
	#		print( slot.get_name(), ": ", slot.item.name )
	#	else:
	#		print( slot.get_name(), ": null")

func get_slot_node_at_position( pos: Vector2 ) -> TextureRect:
	var allSlotNodes = (inventory.get_children())
	
	for node in allSlotNodes:
		
		var nodeRect = node.get_rect()
		if nodeRect.has_point( pos ):
			return node
	
	return null

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			print("END DRAG: ", is_drag_successful())
			if ! is_drag_successful():
				# see if we can drop this item
				if _lastDragSlotNode.item.can_drop:
					var item = _lastDragSlotNode.item
					_lastDragSlotNode.item = null
					Messenger.emit_signal("ITEM_DROPPED", item)
				else:
					#restore image
					_lastDragSlotNode.texture = _lastDragSlotNode.item.texture

func _refresh_ui():
	#for item in items
	pass
