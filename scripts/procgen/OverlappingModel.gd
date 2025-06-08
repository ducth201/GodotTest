extends Object

class_name OverlappingModel

var N = 3

var _input : Image
var _output : Image
var _buffer : Image
var _tiles : TileData
var _colors : Array
var _patterns : Array


func SetInput( img : Image ):
	_input = img

func SetOutput( img : Image ):
	_output = img
	
func Run():
	
	# get palette
	var id = _input.get_data()
	var iw = _input.get_width()
	var ih = _input.get_height()
	var ll = iw * 3 # line length, RGB per pixel
	
	var ii : Array = [] # color-indexed image
	
	for y in range( 0, ih ):
		for x in range( 0, iw ):
			
			var col = [
				id[(x*3+0)+y*ll ],
				id[(x*3+1)+y*ll ],
				id[(x*3+2)+y*ll ]
			]

			if ! _colors.has( col ):
				_colors.push_back( col )
			
			var col_index = -1
			for i in _colors.size():
				if _colors[i] == col:
					col_index = i
					break
					
			ii.push_back( col_index )
	
	# create patterns
	var generated_patterns = []
	var nrOfPatterns = 0;
	for y in range( 0, ih - N + 1 ):
		for x in range( 0, iw - N + 1 ):
			# extract pattern
			
			var pattern = []
			for ny in range( 0, N ):
				for nx in range( 0, N ):
					pattern.push_back( ii[nx+x+(ny+y)*iw] )
					#pattern = [ 
					#	ii[(x+0)+(y+0)*iw],ii[(x+1)+(y+0)*iw],ii[(x+2)+(y+0)*iw],
					#	ii[(x+0)+(y+1)*iw],ii[(x+1)+(y+1)*iw],ii[(x+2)+(y+1)*iw],
					#	ii[(x+0)+(y+2)*iw],ii[(x+1)+(y+2)*iw],ii[(x+2)+(y+2)*iw]
			
			print( "--pattern--" )
			print( pattern )
			
			generated_patterns.push_back( pattern )
			# rotate 3 times
			var p = rotatePattern(pattern)
			generated_patterns.push_back( p )
			p = rotatePattern(p)
			generated_patterns.push_back( p )
			p = rotatePattern(p)
			generated_patterns.push_back( p )
			# mirror
			p = mirrorPattern( p )
			generated_patterns.push_back( p )
			# rotate 3 times
			p = rotatePattern(p)
			generated_patterns.push_back( p )
			p = rotatePattern(p)
			generated_patterns.push_back( p )
			p = rotatePattern(p)
			generated_patterns.push_back( p )

			for gp in generated_patterns:
				if ! _patterns.has( gp ):
					_patterns.push_back( gp )
				
			#if pattern_index == -1:
			#	patterns.push_back(pattern)
			nrOfPatterns = nrOfPatterns + 1
			
	print( "==================" )
	print( "patterns generated" )
	print( "==================" )
	print( "extracted patterns: ", nrOfPatterns)
	print( "generated patterns: ", generated_patterns.size())
	print( "unique patterns: ", _patterns.size())

	# draw patterns
	print( Color.RED )
	print( _colors )
	_output.fill(Color.CYAN)
	drawPattern( _patterns[0], 10,10)
	
func drawPattern( pattern, x, y ):
	
	for py in range( 0, N ):
		for px in range( 0, N ):
			var rgb = _colors[ pattern[px+py*N] ]
			var col:Color = Color( rgb[0]/255.0, rgb[1]/255.0, rgb[2]/255.0 )
			print( "color: ", col )
			_output.set_pixel( x + px, y + py, col )
			
	return 0

func rotatePattern( pattern ):
	var newPattern = []
	
	for y in range( 0, N ):
		for x in range( 0, N ):
			newPattern.push_back( pattern[ ( N - 1 - y ) + ( x * N ) ])
	
	return newPattern
	
func mirrorPattern( pattern ):
	var newPattern = []

	for y in range( 0, N ):
		for x in range( 0, N ):
			newPattern.push_back( pattern[ ( N - 1 - x ) + ( y * N ) ])
	
	return newPattern
	
	
