extends Node
class_name StateMachine

var states : Dictionary = {}
var current_state: State

@export var initial_state : State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transisition.connect(change_state)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.Update(delta)

func force_change_state( new_state: String ):
	var newState = states.get( new_state.to_lower())
	
	if !newState:
		print( new_state.capitalize() + " does not exist in the dictionary of the states, aborting" )
		return
		
	if current_state == newState:
		print( "State is same, aborting")
		return
	
	if current_state:
		var exit_callable = Callable( current_state, "Exit" )
		exit_callable.call_deferred()
		
	newState.Enter()
	
	current_state = newState

func change_state( source_state : State, new_state_name : String ):
	if source_state != current_state:
		print( "Invalid change_state trying from: " + source_state.name + " but currently in: " + current_state.name + ", aborting" )
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print( "New state is empty, aborting")
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
