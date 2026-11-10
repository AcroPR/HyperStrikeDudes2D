class_name FighterPreview
extends TextureButton

@export var mouse: MouseCustom = null
@export var playerID: int = 0

@onready var actionLabel: Label = $Page2/ActionLabel
@onready var background = $Background
@onready var controlButton: PlayerButton = $Page0/ControlButton
@onready var inputSaver: InputSaver = $InputSaver
@onready var labelPageZero: Label = $Page0/Label
@onready var pageZero: Control = $Page0
@onready var pageOne: Control = $Page1
@onready var pageTwo: Control = $Page2

@onready var lightsA: PlayerButton = $Page1/Buttons/Button1/Lights
@onready var heaviesA: PlayerButton = $Page1/Buttons/Button1/Heavies
@onready var specialsA: PlayerButton = $Page1/Buttons/Button1/Specials
@onready var blockA: PlayerButton = $Page1/Buttons/Button1/Block
@onready var jumpA: PlayerButton = $Page1/Buttons/Button1/Jump
@onready var grabA: PlayerButton = $Page1/Buttons/Button1/Grab
@onready var emoteA: PlayerButton = $Page1/Buttons/Button1/Emote
@onready var lightsB: PlayerButton = $Page1/Buttons/Button2/Lights
@onready var heaviesB: PlayerButton = $Page1/Buttons/Button2/Heavies
@onready var specialsB: PlayerButton = $Page1/Buttons/Button2/Specials
@onready var blockB: PlayerButton = $Page1/Buttons/Button2/Block
@onready var jumpB: PlayerButton = $Page1/Buttons/Button2/Jump
@onready var grabB: PlayerButton = $Page1/Buttons/Button2/Grab
@onready var emoteB: PlayerButton = $Page1/Buttons/Button2/Emote


var checkInput: bool
var actionName: String
var isAVersion: bool

func _set_button_shown(button: PlayerButton, input: int) -> void:
	match input:
		-1:
			button.text = ""
		0:
			button.text = "A"
		1:
			button.text = "B"
		2:
			button.text = "X"
		3:
			button.text = "Y"
		4:
			button.text = "LT"
		5:
			button.text = "RT"
		9:
			button.text = "LB"
		10:
			button.text = "RB"
		11:
			button.text = "U"
		12:
			button.text = "D"
		13:
			button.text = "L"
		14:
			button.text = "R"
		_:
			button.text = "?"

func _set_input_buttons() -> void:
	_set_button_shown(lightsA, Controls.playOneInputsA["attack"][1])
	_set_button_shown(lightsB, Controls.playOneInputsB["attack"][1])
	_set_button_shown(heaviesA, Controls.playOneInputsA["heavy"][1])
	_set_button_shown(heaviesB, Controls.playOneInputsB["heavy"][1])
	_set_button_shown(specialsA, Controls.playOneInputsA["special"][1])
	_set_button_shown(specialsB, Controls.playOneInputsB["special"][1])
	_set_button_shown(blockA, Controls.playOneInputsA["block"][1])
	_set_button_shown(blockB, Controls.playOneInputsB["block"][1])
	_set_button_shown(jumpA, Controls.playOneInputsA["jump"][1])
	_set_button_shown(jumpB, Controls.playOneInputsB["jump"][1])
	_set_button_shown(grabA, Controls.playOneInputsA["grab"][1])
	_set_button_shown(grabB, Controls.playOneInputsB["grab"][1])
	_set_button_shown(emoteA, Controls.playOneInputsA["emote"][1])
	_set_button_shown(emoteB, Controls.playOneInputsB["emote"][1])

func _set_player(_playerID: int):
	match _playerID:
		0:
			background.modulate = Color("45bce9")
		1:
			background.modulate = Color("579864ff")
		2:
			background.modulate = Color("af1a5dff")
		3:
			background.modulate = Color("593964ff")

func _ready() -> void:
	_set_player(playerID)
	checkInput = false
	controlButton.playerID = playerID
	texture_normal = null
	labelPageZero.text = ""
	pageZero.visible = true
	pageOne.visible = false
	pageTwo.visible = false
	_set_input_buttons()

func _unhandled_input(event: InputEvent) -> void:
	if !checkInput: return
	if !event.is_pressed(): return
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_START or event.button_index == JOY_BUTTON_BACK:
			var _emptyEvent: InputEvent = InputEventJoypadButton.new()
			_emptyEvent.button_index = -1
			inputSaver._set_input(_emptyEvent, MatchGlobal.players[playerID]["Controller_Index"], actionName, isAVersion) 
		else:
			inputSaver._set_input(event, MatchGlobal.players[playerID]["Controller_Index"], actionName, isAVersion)
		pageZero.visible = false
		pageOne.visible = true
		pageTwo.visible = false
		checkInput = false
		mouse._set_enabled(true)
		_set_input_buttons()
	elif InputEventJoypadMotion:
		if event.axis == JOY_AXIS_TRIGGER_LEFT or event.axis == JOY_AXIS_TRIGGER_RIGHT:
			inputSaver._set_input(event, MatchGlobal.players[playerID]["Controller_Index"], actionName, isAVersion)
			pageZero.visible = false
			pageOne.visible = true
			pageTwo.visible = false
			checkInput = false
			mouse._set_enabled(true)
			_set_input_buttons()

func _on_control_button_pressed() -> void:
	pageZero.visible = false
	pageOne.visible = true
	pageTwo.visible = false

func _on_exit_button_pressed() -> void:
	pageZero.visible = true
	pageOne.visible = false
	pageTwo.visible = false

func _set_input_page(labelText: String, _actionName: String, _isAVersion: bool):
	pageZero.visible = false
	pageOne.visible = false
	pageTwo.visible = true
	actionLabel.text = labelText
	actionName = _actionName
	mouse._set_enabled(false)
	checkInput = true
	isAVersion = _isAVersion

func _on_lights_a_pressed() -> void:
	_set_input_page("Light Attack", "attack", true)

func _on_lights_b_pressed() -> void:
	_set_input_page("Light Attack", "attack", false)

func _on_heavies_a_pressed() -> void:
	_set_input_page("Heavy Attack", "heavy", true)

func _on_heavies_b_pressed() -> void:
	_set_input_page("Heavy Attack", "heavy", false)

func _on_specials_a_pressed() -> void:
	_set_input_page("Special Attack", "special", true)

func _on_specials_b_pressed() -> void:
	_set_input_page("Special Attack", "special", false)

func _on_block_a_pressed() -> void:
	_set_input_page("Block", "block", true)

func _on_block_b_pressed() -> void:
	_set_input_page("Block", "block", false)

func _on_jump_a_pressed() -> void:
	_set_input_page("Jump", "jump", true)

func _on_jump_b_pressed() -> void:
	_set_input_page("Jump", "jump", false)

func _on_grab_a_pressed() -> void:
	_set_input_page("Grab", "grab", true)

func _on_grab_b_pressed() -> void:
	_set_input_page("Grab", "grab", false)

func _on_emote_a_pressed() -> void:
	_set_input_page("Emote", "emote", true)

func _on_emote_b_pressed() -> void:
	_set_input_page("Emote", "emote", false)
