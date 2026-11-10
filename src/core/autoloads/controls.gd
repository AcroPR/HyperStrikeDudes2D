extends Node

const CONTROL_PATH_ZERO_A: String = "user://control0A.json"
const CONTROL_PATH_ONE_A: String = "user://control1A.json"
const CONTROL_PATH_TWO_A: String = "user://control2A.json"
const CONTROL_PATH_THREE_A: String = "user://control3A.json"
const KEYBOARD_PATH: String = "user://controlKeyboard.json"
const CONTROL_PATH_ZERO_B: String = "user://control0B.json"
const CONTROL_PATH_ONE_B: String = "user://control1B.json"
const CONTROL_PATH_TWO_B: String = "user://control2B.json"
const CONTROL_PATH_THREE_B: String = "user://control3B.json"

# "input name": [is_analog, input, direction (optional)]
var inputsA = {
	"move_up":    [true, JOY_AXIS_LEFT_Y, -1.0],
	"move_down":  [true, JOY_AXIS_LEFT_Y,  1.0],
	"move_left":  [true, JOY_AXIS_LEFT_X, -1.0],
	"move_right": [true, JOY_AXIS_LEFT_X,  1.0],

	"attack_up":    [true, JOY_AXIS_RIGHT_Y, -1.0],
	"attack_down":  [true, JOY_AXIS_RIGHT_Y,  1.0],
	"attack_left":  [true, JOY_AXIS_RIGHT_X, -1.0],
	"attack_right": [true, JOY_AXIS_RIGHT_X,  1.0],

	"attack": [false, JOY_BUTTON_A],
	"special":   [false, JOY_BUTTON_B],
	"heavy":   [false, JOY_BUTTON_X],
	"jump":  [false, JOY_BUTTON_Y],
	"grab": [false, JOY_BUTTON_RIGHT_SHOULDER],

	# Triggers = analog (0 → 1) 
	"block": [true, JOY_AXIS_TRIGGER_RIGHT, 1.0],
	"walk":  [true, JOY_AXIS_TRIGGER_LEFT,  1.0],
	
	"emote": [false, JOY_BUTTON_LEFT_SHOULDER],
	"pause": [false, JOY_BUTTON_START],
	"accept": [false, JOY_BUTTON_A],
	"cancel": [false, JOY_BUTTON_B],
}

var inputsB = {
	"move_up":    [true, -1, -1.0],
	"move_down":  [true, -1,  1.0],
	"move_left":  [true, -1, -1.0],
	"move_right": [true, -1,  1.0],

	"attack_up":    [true, -1, -1.0],
	"attack_down":  [true, -1,  1.0],
	"attack_left":  [true, -1, -1.0],
	"attack_right": [true, -1,  1.0],

	"attack": [false, -1],
	"special":   [false, -1],
	"heavy":   [false, -1],
	"jump":  [false, -1],
	"grab": [false, -1],

	# Triggers = analog (0 → 1) 
	"block": [true, -1, 1.0],
	"walk":  [true, -1,  1.0],
	
	"emote": [false, -1],
	"pause": [false, -1],
	"accept": [false, -1],
	"cancel": [false, -1],
}

var playOneInputsA
var playTwoInputsA
var playThreeInputsA
var playFourInputsA
var playKeyboardInputs
var playOneInputsB
var playTwoInputsB
var playThreeInputsB
var playFourInputsB

func _save_input(controllerID: int):
	var file: FileAccess
	match controllerID:
		0:
			file = FileAccess.open(CONTROL_PATH_ZERO_A, FileAccess.WRITE)
			file.store_string(JSON.stringify(playOneInputsA, "\t"))
			file.close()
			file = FileAccess.open(CONTROL_PATH_ZERO_B, FileAccess.WRITE)
			file.store_string(JSON.stringify(playOneInputsB, "\t"))
			file.close()
		1:
			file = FileAccess.open(CONTROL_PATH_ONE_A, FileAccess.WRITE)
			file.store(playTwoInputsA)
			file.close()
			file = FileAccess.open(CONTROL_PATH_ONE_B, FileAccess.WRITE)
			file.store(playTwoInputsB)
			file.close()
		2:
			file = FileAccess.open(CONTROL_PATH_TWO_A, FileAccess.WRITE)
			file.store(playThreeInputsA)
			file.close()
			file = FileAccess.open(CONTROL_PATH_TWO_B, FileAccess.WRITE)
			file.store(playThreeInputsB)
			file.close()
		3:
			file = FileAccess.open(CONTROL_PATH_THREE_A, FileAccess.WRITE)
			file.store(playFourInputsA)
			file.close()
			file = FileAccess.open(CONTROL_PATH_THREE_B, FileAccess.WRITE)
			file.store(playFourInputsB)
			file.close()
		_:
			file = FileAccess.open(KEYBOARD_PATH, FileAccess.WRITE)
			file.store(playKeyboardInputs)
			file.close()

func _load_input(controllerID: int, isAVersion: bool) -> Dictionary:
	var returned_inputs: Dictionary
	var file: FileAccess
	match controllerID:
		0:
			match isAVersion:
				true:
					if FileAccess.file_exists(CONTROL_PATH_ZERO_A):
						file = FileAccess.open(CONTROL_PATH_ZERO_A, FileAccess.READ)
						var jsonText = file.get_as_text()
						var json = JSON.new()
						json.parse(jsonText)
						returned_inputs = json.data
						file.close()
				false:
					if FileAccess.file_exists(CONTROL_PATH_ZERO_B):
						file = FileAccess.open(CONTROL_PATH_ZERO_B, FileAccess.READ)
						var jsonText = file.get_as_text()
						var json = JSON.new()
						json.parse(jsonText)
						returned_inputs = json.data
						file.close()
		1:
			match isAVersion:
				true:
					if FileAccess.file_exists(CONTROL_PATH_ONE_A):
						file = FileAccess.open(CONTROL_PATH_ONE_A, FileAccess.READ)
						returned_inputs = file.get_var()
						file.close()
				false:
					if FileAccess.file_exists(CONTROL_PATH_ONE_B):
						file = FileAccess.open(CONTROL_PATH_ONE_B, FileAccess.READ)
						returned_inputs = file.get_var()
						file.close()
		2:
			match isAVersion:
				true:
					if FileAccess.file_exists(CONTROL_PATH_TWO_A):
						file = FileAccess.open(CONTROL_PATH_TWO_A, FileAccess.READ)
						returned_inputs = file.get_var()
						file.close()
				false:
					if FileAccess.file_exists(CONTROL_PATH_TWO_B):
						file = FileAccess.open(CONTROL_PATH_TWO_B, FileAccess.READ)
						returned_inputs = file.get_var()
						file.close()
		3:
			match isAVersion:
				true:
					if FileAccess.file_exists(CONTROL_PATH_THREE_A):
						file = FileAccess.open(CONTROL_PATH_THREE_A, FileAccess.READ)
						returned_inputs = file.get_var()
						file.close()
				false:
					if FileAccess.file_exists(CONTROL_PATH_THREE_B):
						file = FileAccess.open(CONTROL_PATH_THREE_B, FileAccess.READ)
						returned_inputs = file.get_var()
						file.close()
		_:
			if FileAccess.file_exists(KEYBOARD_PATH):
				file = FileAccess.open(KEYBOARD_PATH, FileAccess.READ)
				returned_inputs = file.get_var()
				file.close()
	if returned_inputs.is_empty():
		match isAVersion:
			true:
				returned_inputs = inputsA
			_:
				returned_inputs = inputsB
	return returned_inputs

func _ready() -> void:
	playOneInputsA = _load_input(0, true)
	playTwoInputsA = _load_input(1, true)
	playThreeInputsA = _load_input(2, true)
	playFourInputsA = _load_input(3, true)
	playOneInputsB = _load_input(0, false)
	playTwoInputsB = _load_input(1, false)
	playThreeInputsB = _load_input(2, false)
	playFourInputsB = _load_input(3, false)
	_add_actions(playOneInputsA, 0)
	_add_actions(playTwoInputsA, 1)
	_add_actions(playThreeInputsA, 2)
	_add_actions(playFourInputsA, 3)
	_add_actions(playOneInputsB, 0)
	_add_actions(playTwoInputsB, 1)
	_add_actions(playThreeInputsB, 2)
	_add_actions(playFourInputsB, 3)

func _add_actions(_inputs, controllerID) -> void:
	for action in _inputs:
		var inputAction = action + "_" + str(controllerID)
		
		if not InputMap.has_action(inputAction):
			InputMap.add_action(inputAction)
			
		var is_analog = _inputs[action][0]
		var input_value = _inputs[action][1]
		
		if input_value == -1: continue
		
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
