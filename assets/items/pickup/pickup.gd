extends Node2D

class_name Pickup

@export var item : ItemResource = null

func _ready():
	if item != null:
		add_item( item )

func add_item( itemResource : ItemResource ):
	item = itemResource
	$TextureRect/Container/TextureRect.texture = item.texture

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	
	if area.name == "player":
		Messenger.ITEM_PICKED_UP.emit( self )
