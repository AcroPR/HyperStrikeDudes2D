class_name StateMachine
extends Node

@export_category("States")
@export var startingState: State

var currentState: State

# Get current state
func _get_current_state() -> State:
	return currentState

# Get string of the current state
func _get_current_state_name() -> String:
	return str(currentState).get_slice(":",0)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if currentState:
		currentState.exit()

	currentState = new_state
	currentState.enter()

# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = currentState.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = currentState.process_frame(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = currentState.process_input(event)
	if new_state:
		change_state(new_state)
