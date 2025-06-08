@icon( "res://icons.svg" )

extends Area2D

@export var _resource: CharacterResource

func _ready():
	print( "Spider ready" )
	print( _resource.health )
	print( _resource.dmg(15))
