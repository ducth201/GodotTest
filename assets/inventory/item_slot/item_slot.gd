class_name ItemSlot

extends TextureRect

@export var item : ItemResource = null
@onready var textureRect = $TextureRect

var is_full : bool = false

func _ready():
	$PanelContainer.visible = false

func add_item( itemResource : ItemResource ):
	
	if item != null:
		if item.name == itemResource.name && item.max_stack_size > 1 && item.cur_stack_size < item.max_stack_size:
			$PanelContainer.visible = true
			item.cur_stack_size = item.cur_stack_size + 1
			$PanelContainer/Label.text = str(item.cur_stack_size)
			if item.cur_stack_size == item.max_stack_size:
				is_full = true
			return
	item = itemResource
	$TextureRect.texture = item.texture
	item.container = get_parent().name
	item.containerPosition = int(name.split("ItemSlot")[1])
	
func clear():
	item = null
	$TextureRect.texture = null
	$PanelContainer.visible = false
	is_full = false
