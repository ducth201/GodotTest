@icon( "../gfx/icons/icon_map.png" )

extends Node2D

class_name Map

var all_tiles : Array
var width = 17
var height = 9
var blackTile : WangTile
var grid
# Called when the node enters the scene tree for the first time.
func _ready():
	print( "map ready" )
	print( "=========" )
	#wangTiles()
	Overlap()
	
func Overlap():
		
	var test : OverlappingModel = OverlappingModel.new()
	
	test.SetInput( $input.texture.get_image() )
	test.SetOutput( $output.texture.get_image() )
	test.Run()

func wangTiles():	
	#
	# create wangtiles tiletype lookup
	#
	for tile in ($Tiles.get_children() as Array[WangTile]):
		all_tiles.insert( tile.res.TileType, tile )
	
	#
	# fill with black
	#
	blackTile = all_tiles[15]
	for xpos in range( 0,width ):
		for ypos in range( 0,height):
			$TileMap.set_cell(0,Vector2(xpos,ypos),0,blackTile.res.location)
	
	#
	# remove black tile from possible fields
	#
	all_tiles.pop_back();
	
	#
	# create grid with all possibilities
	#
	grid=Array()
	grid.resize(height)
	for i in range(height):
		grid[i]=Array()
		grid[i].resize(width)
		for j in range(width):
			grid[i][j]=all_tiles.duplicate(true)
	
	#
	# add a tile somewhere in the center
	#
	#var randomtile = randi_range(0,14) # anything but the black tile
	#var tilepos = Vector2i(8,4);
	#var tile = all_tiles[ randomtile ] as WangTile;
	
	#$TileMap.set_cell( 0, tilepos, 0, tile.res.location )
	#grid[4][8] = tile;

	#
	# update grid for first tile
	#
	#updateGrid( grid, Vector2i( 8, 4 ) )
	$Button.connect("pressed",go)
func go():
	#	
	# place another tile
	#
	$Button.hide()
	var tilenr = 0
	while( tilenr < height*width ):
		tilenr = tilenr + 1
		placeTile( all_tiles, grid )
		await get_tree().create_timer(0.01).timeout
	#for tile in ($Tiles.get_children() as Array[WangTile]):

func placeTile( all_tiles, grid ):
	# get array of tile(s) locations with lowest count
	var lowestCountTiles : Array[Vector2i]
	var lowestCount = 16
	for i in range(height):
		for j in range(width):
			# var tileCount = grid[i][j].size()
			var curtile = grid[i][j]
			if typeof( curtile ) == TYPE_ARRAY:
				# print( "x:", j, " y:", i, " => array of size: ", curtile.size() )
				if curtile.size() < lowestCount:
					# print( "lower!!!" )
					lowestCountTiles.clear()
					lowestCount = curtile.size()
				if curtile.size() == lowestCount:
					lowestCountTiles.append( Vector2i(j,i) )
				
	#print( "lowest count tiles" )
	#print( "==================" )
	#for pos in lowestCountTiles:
		# print( "x:", pos.x, " y:", pos.y)
	#
	# pick random item from lowest count tiles
	# 
	var chosen_loc = lowestCountTiles.pick_random()
	#print( "chosen!!! x:", chosen_loc.x, " y:", chosen_loc.y)
	var chosen_tile : WangTile = (grid[chosen_loc.y][chosen_loc.x] as Array[WangTile]).pick_random()
	grid[chosen_loc.y][chosen_loc.x] = chosen_tile
	$TileMap.set_cell( 0, chosen_loc, 0, chosen_tile.res.location )
	updateGrid(grid,chosen_loc)

func updateGrid( grid, pos : Vector2i ):
	# get tile at position
	#print( "location: ", pos.x, ":", pos.y)
	var tile = ( grid[pos.y][pos.x] as WangTile )
	var possibilities
	
	# update grid neighbours
	if pos.y - 1 >= 0 && typeof( grid[pos.y-1][pos.x] ) == TYPE_ARRAY:
		if typeof( grid[pos.y-1][pos.x] ) == TYPE_ARRAY:
			possibilities = grid[pos.y-1][pos.x] as Array[WangTile]
			possibilities = possibilities.filter(func(t:WangTile): return t.res.bottom == tile.res.top)
			grid[pos.y-1][pos.x] = possibilities
	if pos.y + 1 < height:
		if typeof( grid[pos.y+1][pos.x] ) == TYPE_ARRAY:
			possibilities = grid[pos.y+1][pos.x] as Array[WangTile]
			possibilities = possibilities.filter(func(t:WangTile): return t.res.top == tile.res.bottom)
			grid[pos.y+1][pos.x] = possibilities
	if pos.x - 1 >= 0:
		if typeof( grid[pos.y][pos.x-1] ) == TYPE_ARRAY:
			possibilities = grid[pos.y][pos.x-1] as Array[WangTile]
			possibilities = possibilities.filter(func(t:WangTile): return t.res.right == tile.res.left)
			grid[pos.y][pos.x-1] = possibilities
	if pos.x + 1 < width:
		if typeof( grid[pos.y][pos.x+1] ) == TYPE_ARRAY:
			possibilities = grid[pos.y][pos.x+1] as Array[WangTile]
			possibilities = possibilities.filter(func(t:WangTile): return t.res.left == tile.res.right)
			grid[pos.y][pos.x+1] = possibilities
