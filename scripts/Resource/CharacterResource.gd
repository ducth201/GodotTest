extends Resource

class_name CharacterResource

@export var name: String
@export var health: int
@export var strength: int
@export var speed: int

func dmg(amount):
	health -= amount
	return health
