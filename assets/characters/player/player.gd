extends Node2D

@export var _resource: CharacterResource

var _pickup : PackedScene = preload("res://assets/items/pickup/pickup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.connect("ITEM_DROPPED", drop_item )

func drop_item( item : ItemResource ):
	
	var pickup = _pickup.instantiate()
	
	pickup.add_item(item)
	pickup.global_position = get_global_mouse_position() - pickup.item.texture.get_size() / 2
	
	get_parent().add_child(pickup)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	var velocity = Input.get_vector("Left", "Right", "Up", "Down")
	
	
	#print( pow( pow( velocity.x, 2 ) + pow( velocity.y, 2), .5 ) )
	#print( position )
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
		
	position.x += velocity.x * _resource.speed * _delta
	position.y += velocity.y * _resource.speed * _delta
