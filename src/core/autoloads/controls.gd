extends Node

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

func _ready() -> void:
	for controllerID in range(0, 4):
		for action in inputs:
			var inputAction = action + "_" + str(controllerID)
			
			if not InputMap.has_action(inputAction):
				InputMap.add_action(inputAction)
				
			var is_analog = inputs[action][0]
			var input_value = inputs[action][1]
			
			if is_analog:
				var axis_event = InputEventJoypadMotion.new()
				axis_event.device = controllerID
				axis_event.axis = input_value
				
				# Use direction if provided, otherwise default to 1.0
				var direction = inputs[action][2] if inputs[action].size() > 2 else 1.0
				axis_event.axis_value = direction
				
				InputMap.action_add_event(inputAction, axis_event)
				
			else:
				var button_event = InputEventJoypadButton.new()
				button_event.device = controllerID
				button_event.button_index = input_value
				
				InputMap.action_add_event(inputAction, button_event)
