extends Node2D

class_name Level

@export var width : int
@export var height : int
@export var Items : Array[ItemResource]

var _frog : PackedScene = preload("res://assets/characters/frog/frog.tscn")

func _init():
	
	# set seed
	seed( int( Time.get_unix_time_from_system() * 1000 ) )
	# seed( 1 )

	
# Called when the node enters the scene tree for the first time.
	
func _ready():
	
	print( "playground ready!" )
	var frog = _frog.instantiate()
	frog.position.x = 100
	frog.position.y = 100
	add_child( frog )
	
	# show input
	# add_child(input)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
