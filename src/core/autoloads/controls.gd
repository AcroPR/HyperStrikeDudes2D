extends Node

const CONTROL_PATH_ZERO: String = "user://control0.json"
const CONTROL_PATH_ONE: String = "user://control1.json"
const CONTROL_PATH_TWO: String = "user://control2.json"
const CONTROL_PATH_THREE: String = "user://control3.json"
const KEYBOARD_PATH: String = "user://controlKeyboard.json"

# "input name": [is_analog, input, direction (optional)]
var inputs = {
	"move_up":    [true, JOY_AXIS_LEFT_Y, -1.0],
	"move_down":  [true, JOY_AXIS_LEFT_Y,  1.0],
	"move_left":  [true, JOY_AXIS_LEFT_X, -1.0],
	"move_right": [true, JOY_AXIS_LEFT_X,  1.0],

	"attack_up":    [true, JOY_AXIS_RIGHT_Y, -1.0],
	"attack_down":  [true, JOY_AXIS_RIGHT_Y,  1.0],
	"attack_left":  [true, JOY_AXIS_RIGHT_X, -1.0],
	"attack_right": [true, JOY_AXIS_RIGHT_X,  1.0],

	"attack": [false, JOY_BUTTON_Y],
	"special":   [false, JOY_BUTTON_X],
	"heavy":   [false, JOY_BUTTON_A],
	"jump":  [false, JOY_BUTTON_B],
	"grab": [false, JOY_BUTTON_RIGHT_SHOULDER],

	# Triggers = analog (0 → 1) 
	"block": [true, JOY_AXIS_TRIGGER_RIGHT, 1.0],
	"walk":  [true, JOY_AXIS_TRIGGER_LEFT,  1.0],
	
	"emote": [false, JOY_BUTTON_LEFT_SHOULDER],
	"pause": [false, JOY_BUTTON_START],
	"accept": [false, JOY_BUTTON_A],
	"cancel": [false, JOY_BUTTON_B],
}

var playOneInputs
var playTwoInputs
var playThreeInputs
var playFourInputs
var playKeyboardInputs

func _save_input(controllerID: int):
	var file: FileAccess
	match controllerID:
		0:
			file = FileAccess.open(CONTROL_PATH_ZERO, FileAccess.WRITE)
			file.store(playOneInputs)
			file.close()
		1:
			file = FileAccess.open(CONTROL_PATH_ONE, FileAccess.WRITE)
			file.store(playTwoInputs)
			file.close()
		2:
			file = FileAccess.open(CONTROL_PATH_TWO, FileAccess.WRITE)
			file.store(playThreeInputs)
			file.close()
		3:
			file = FileAccess.open(CONTROL_PATH_THREE, FileAccess.WRITE)
			file.store(playFourInputs)
			file.close()
		_:
			file = FileAccess.open(KEYBOARD_PATH, FileAccess.WRITE)
			file.store(playKeyboardInputs)
			file.close()

func _load_input(controllerID: int) -> Dictionary:
	var returned_inputs: Dictionary
	var file: FileAccess
	match controllerID:
		0:
			if FileAccess.file_exists(CONTROL_PATH_ZERO):
				file = FileAccess.open(CONTROL_PATH_ZERO, FileAccess.READ)
				returned_inputs = file.get_var()
				file.close()
		1:
			if FileAccess.file_exists(CONTROL_PATH_ONE):
				file = FileAccess.open(CONTROL_PATH_ONE, FileAccess.READ)
				returned_inputs = file.get_var()
				file.close()
		2:
			if FileAccess.file_exists(CONTROL_PATH_TWO):
				file = FileAccess.open(CONTROL_PATH_TWO, FileAccess.READ)
				returned_inputs = file.get_var()
				file.close()
		3:
			if FileAccess.file_exists(CONTROL_PATH_THREE):
				file = FileAccess.open(CONTROL_PATH_THREE, FileAccess.READ)
				returned_inputs = file.get_var()
				file.close()
		_:
			if FileAccess.file_exists(KEYBOARD_PATH):
				file = FileAccess.open(KEYBOARD_PATH, FileAccess.READ)
				returned_inputs = file.get_var()
				file.close()
	if returned_inputs.is_empty(): returned_inputs = inputs
	return returned_inputs

func _ready() -> void:
	playOneInputs = _load_input(0)
	playTwoInputs = _load_input(1)
	playThreeInputs = _load_input(2)
	playFourInputs = _load_input(3)
	_add_actions(playOneInputs, 0)
	_add_actions(playTwoInputs, 1)
	_add_actions(playThreeInputs, 2)
	_add_actions(playFourInputs, 3)

func _add_actions(_inputs, controllerID) -> void:
	for action in _inputs:
		var inputAction = action + "_" + str(controllerID)
		
		if not InputMap.has_action(inputAction):
			InputMap.add_action(inputAction)
			
		var is_analog = _inputs[action][0]
		var input_value = _inputs[action][1]
		
		if is_analog:
			var axis_event = InputEventJoypadMotion.new()
			axis_event.device = controllerID
			axis_event.axis = input_value
			
			# Use direction if provided, otherwise default to 1.0
			var direction = _inputs[action][2] if _inputs[action].size() > 2 else 1.0
			axis_event.axis_value = direction
			
			InputMap.action_add_event(inputAction, axis_event)
			
		else:
			var button_event = InputEventJoypadButton.new()
			button_event.device = controllerID
			button_event.button_index = input_value
			
			InputMap.action_add_event(inputAction, button_event)
