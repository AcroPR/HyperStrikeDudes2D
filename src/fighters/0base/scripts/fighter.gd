@tool
class_name Fighter
extends CharacterBody2D

signal dead_fighter

const WALK_THRESHOLD: float = 0.25
const RUN_THRESHOLD: float = 0.8

@export_tool_button("Open Hitbox Animator", "Callable") var openHitboxAnimator = _open_hitbox_animator
@export_category("Fighter State Machine")
@export var stateMachine: StateMachine

@export_category("Fighter Attributes")
@export var airDrift: float = 3.75
@export var airJumpHeight: float = 12.25
@export var airSpeed: float = 7.4
@export_range(0, 30) var dashFrames: int = 15
@export var dashSpeed: float = 8.25
@export var fastFallMultiplier: float = 2.0
@export_range(0.0, 1.0) var groundFriction: float = 0.85
@export var hopHeight: float = 7.45
@export var jumpHeight: float = 12.25
@export_range(4, 10) var jumpSquatFrames: int = 4
@export_range(1, 99) var maxAirJumps: int = 1
@export var runSpeed: float = 6.75
@export var weight: float = 27
@export var walkSpeed: float = 4.80

@export_category("Game Load Values")
@export var facingRight = true
@export_range(0, 3) var playerID: int = 0

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hitboxManager: HitboxManager = $ModelCollisions/HitboxManager
@onready var inputComponent = $InputComponent
@onready var ledgeGrabBox: Area2D = $ModelCollisions/LedgeGrabBox
@onready var ledgePosition: Marker2D = $ModelCollisions/LedgePosition
@onready var model = $SubViewportContainer/SubViewport/OffScreenCamera2D/Model
@onready var modelCollisions: Node2D = $ModelCollisions
@onready var offScreenMarker: OffScreenMarker = $OffScreenMarker
@onready var stateLabel = $StateLabel

var fighterIcon: FighterIcon

var airJumpCount: int = 0
var isFastFalling: bool = false
var percent: int = 0 : set = _update_percent
var landingFrames: int = 0
var ledgeGrabCount: int = 0
var ledgeHeld: Ledge

func _update_percent(_percent: int):
	percent = _percent
	if fighterIcon != null:
		fighterIcon._set_percent(percent)

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

func _open_hitbox_animator():
	var tool = HitboxAnimatorTool.new()
	tool._run()

func _set_face():
	match facingRight:
		true:
			model.scale.x = 1
			modelCollisions.scale.x = 1
		false:
			model.scale.x = -1
			modelCollisions.scale.x = -1

func _set_face_with_move_dir(moveDir):
	match moveDir:
		[true,false]:
			facingRight = false
			model.scale.x = -1
			modelCollisions.scale.x = -1
		[false,true]:
			facingRight = true
			model.scale.x = 1
			modelCollisions.scale.x = 1

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	isFastFalling = false
	ledgeHeld = null
	inputComponent.controllerID = MatchGlobal.players[playerID]["Controller_Index"]
	stateMachine.init(self, model, inputComponent)
	_set_face()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	stateMachine.process_frame(delta)
	stateLabel.text = "State: " + stateMachine._get_current_state_name()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	stateMachine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	stateMachine.process_input(event)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.collision_layer & (1 << 6):
		emit_signal("dead_fighter",playerID)

func _on_ledge_grab_box_area_entered(ledge: Ledge) -> void:
	if ledgeGrabCount < GameModifiers.ledgeGrabLimit:
		ledgeGrabCount += 1
		ledgeHeld = ledge
		facingRight = !ledgeHeld.facingRight
		_set_face()
		ledgeHeld._set_ledge_grab(self)
		_set_ledge_position()
		stateMachine.change_state($FighterStateMachine/AirMovement/Ledge)

func _off_ledge():
	ledgeGrabCount = 0
	ledgeHeld = null
	velocity.y = -1250
	stateMachine.change_state($FighterStateMachine/AirMovement/Air)

func _set_ledge_position():
	var newPosition = ledgeHeld.global_position - ledgePosition.position
	global_position = newPosition


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	offScreenMarker.visible = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	offScreenMarker.visible = true
