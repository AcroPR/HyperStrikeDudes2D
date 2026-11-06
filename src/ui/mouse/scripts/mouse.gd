class_name MouseCustom
extends CharacterBody2D

@export var fighterPreview: FighterPreview
@export_range(0, 3) var playerID: int = 0
var controllerID: int = 0

var fighterID: String = ""
var fighterName: String = ""
var filePath: String = ""
var selectedFighter: bool

@onready var inputComponent: InputComponent = $InputComponent
@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D

var mouseSpeed: int = 50000

func _set_player(_playerID: int):
	label.text = "P"+str(playerID+1)
	match _playerID:
		0:
			sprite.modulate = Color("45bce9")
		1:
			sprite.modulate = Color("579864ff")
		2:
			sprite.modulate = Color("af1a5dff")
		3:
			sprite.modulate = Color("593964ff")

func _shows_preview() -> bool:
	return fighterPreview.texture_normal != null

func _update_fighter_id_and_name(_fighterID: String, _fighterName: String) -> void:
	if selectedFighter: return
	fighterID = _fighterID
	fighterName = _fighterName
	_update_file_path()
	_update_preview()

func _update_file_path():
	filePath = "res://assets/ui/fighter_select/fighters/preview/" + fighterID + "/0.png"

func _update_preview():
	if FileAccess.file_exists(filePath):
		fighterPreview.texture_normal = load(filePath)
		fighterPreview.label.text = fighterName
	else:
		fighterPreview.texture_normal = null
		fighterPreview.label.text = ""

func _ready() -> void:
	selectedFighter = false
	_set_player(playerID)
	inputComponent.controllerID = playerID

func _process(_delta: float) -> void:
	if inputComponent._just_pressed("accept") and fighterID != "":
		selectedFighter = true
		MatchGlobal.players[playerID].Fighter = fighterID
	if inputComponent._just_pressed("cancel"):
		selectedFighter = false
		_update_fighter_id_and_name("","")

func _physics_process(delta: float) -> void:
	var xDir = inputComponent._get_strength("move_right") - inputComponent._get_strength("move_left")
	var yDir = inputComponent._get_strength("move_down") - inputComponent._get_strength("move_up")
	
	velocity.x = xDir * mouseSpeed * delta
	velocity.y = yDir * mouseSpeed * delta
	
	move_and_slide()
