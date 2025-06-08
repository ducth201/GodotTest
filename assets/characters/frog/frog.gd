extends Node2D

var move_speed : float = 30.0
var move_dir : Vector2 = Vector2(30,10)

var start_pos : Vector2
var target_pos : Vector2

func _ready():
	# print( "Frog ready" )
	# print( "health: %d" % _resource.health )
	# print( "health after 8 dmg: " + _resource.dmg(8))
	
	var newAngle = fmod( randi(), ( 2.0 * PI ) );
	# print( "angle: %f" % newAngle )
	rotation = newAngle
	start_pos = global_position
	move_dir = Vector2.from_angle(newAngle + PI / 2 ) * 20
	target_pos = start_pos + move_dir

func _process( delta ):
	global_position = global_position.move_toward(target_pos, delta * move_speed )
	
	if global_position == target_pos:
		if global_position == start_pos:
			target_pos = start_pos + move_dir
		else:
			target_pos = start_pos
