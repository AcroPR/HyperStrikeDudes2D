class_name Fighter
extends CharacterBody2D

const WALK_THRESHOLD: float = 0.25
const RUN_THRESHOLD: float = 0.8

@export_category("Fighter State Machine")
@export var stateMachine: StateMachine

@export_category("Fighter Attributes")
@export_range(4, 10) var jumpSquatFrames: int = 4
@export_range(0, 30) var dashFrames: int = 15
@export var walkSpeed: float = 4.80
@export var dashSpeed: float = 8.25
@export var runSpeed: float = 6.75
@export var airSpeed: float = 7.4
@export var airDrift: float = 3.75
@export var hopHeight: float = 7.45
@export var jumpHeight: float = 12.25
@export var weight: float = 27
@export_range(0.0, 1.0) var groundFriction: float = 0.85
@export var canHoldShoot: bool = false
@export_range(5, 999) var shootLockOutFrames: int = 5

@export_category("Game Load Values")
@export var facingRight = true
@export_range(0, 3) var playerID: int = 0

@onready var inputComponent = $InputComponent
@onready var model = $Model
@onready var stateLabel = $StateLabel

var landingFrames: int = 0

func _can_move() -> bool:
	# Move Direction (Horizontal)
	var moveDir = [inputComponent._pressed("move_left"),inputComponent._pressed("move_right")]
	# Returns true if only left or right is pressed
	return !(moveDir[0] and moveDir[1]) and !(!moveDir[0] and !moveDir[1])

func _get_velocity(_float: float) -> float:
	return _float * 100

func _is_dashing_correctly() -> bool:
	if inputComponent._pressed("move_left") and !facingRight:
		return true
	elif inputComponent._pressed("move_right") and facingRight:
		return true
	return false

func _set_face(moveDir):
	match moveDir:
		[true,false]:
			facingRight = false
			model.scale.x = -1
		[false,true]:
			facingRight = true
			model.scale.x = 1

func _ready() -> void:
	#inputComponent.controllerID = MatchGlobal.players[playerID]["Controller_Index"]
	stateMachine.init(self, model, inputComponent)
	match facingRight:
		true:
			model.scale.x = 1
		false:
			model.scale.x = -1

func _process(delta: float) -> void:
	stateMachine.process_frame(delta)
	stateLabel.text = "State: " + stateMachine._get_current_state_name()

func _physics_process(delta: float) -> void:
	stateMachine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	stateMachine.process_input(event)
