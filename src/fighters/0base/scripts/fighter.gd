@tool
class_name Fighter
extends CharacterBody2D

signal dead_fighter
signal respawn_fighter

const MAX_BLOCK_HEALTH: float = 55.0
const RUN_THRESHOLD: float = 0.8
const WALK_THRESHOLD: float = 0.25

enum StaleValue { NONE, FRESH, LEVEL_THREE, LEVEL_TWO, LEVEL_ONE, STALE}

@export_tool_button("Open Hitbox Animator", "Callable") var openHitboxAnimator = _open_hitbox_animator
@export_category("Fighter Names")
@export var fighterFolderName: String = "0base"
@export var fighterName: String = "Fighter"
@export_category("Fighter State Machine")
@export var stateMachine: StateMachine

@export_category("Attack States")
@export var airAttackDownState: State
@export var airAttackNeutralState: State
@export var airAttackSideState: State
@export var airAttackUpState: State
@export var attackDownState: State
@export var attackNeutralState: State
@export var attackSideState: State
@export var attackUpState: State
@export var heavyDownState: State
@export var heavySideState: State
@export var heavyUpState: State
@export var specialDownState: State
@export var specialNeutralState: State
@export var specialSideState: State
@export var specialUpState: State

@export_category("Fighter Attributes")
@export var airDrift: float = 3.75
@export var airJumpHeight: float = 12.25
@export var airSpeed: float = 7.4
@export_range(8, 30) var dashFrames: int = 15
@export var dashSpeed: float = 8.25
@export var fastFallMultiplier: float = 2.0
@export_range(0.0, 1.0) var groundFriction: float = 0.35
@export var hopHeight: float = 7.45
@export var jumpHeight: float = 12.25
@export_range(4, 10) var jumpSquatFrames: int = 4
@export_range(1, 99) var maxAirJumps: int = 1
@export var moonWalkSpeed: float = 8.25
@export var rollSpeed: float = 750.0
@export var runSpeed: float = 6.75
@export var weight: float = 27
@export var walkSpeed: float = 4.80

@export_category("Game Load Values")
@export var facingRight = true
@export_range(0, 3) var playerID: int = 0

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var blockBubble: BlockBubble = $BlockBubble
@onready var blockHealthTimer: Timer = $BlockHealthTimer
@onready var hitboxManager: HitboxManager = $ModelCollisions/HitboxManager
@onready var hurtboxes: Node2D = $ModelCollisions/Hurtboxes
@onready var inputComponent = $InputComponent
@onready var ledgeGrabBox: Area2D = $ModelCollisions/LedgeGrabBox
@onready var ledgePosition: Marker2D = $ModelCollisions/LedgePosition
@onready var model = $SubViewportContainer/SubViewport/OffScreenCamera2D/Model
@onready var modelCollisions: Node2D = $ModelCollisions
@onready var offScreenMarker: OffScreenMarker = $OffScreenMarker
@onready var shaker: Shaker = $Shaker
@onready var stateLabel = $StateLabel

@onready var deadState: State = $FighterStateMachine/Extras/Dead
@onready var grabStunState: State = $FighterStateMachine/Extras/GrabStun
@onready var hitState: State = $FighterStateMachine/Extras/Hit
@onready var idleState: State = $FighterStateMachine/GroundMovement/Idle
@onready var ledgeState: State = $FighterStateMachine/AirMovement/Ledge
@onready var pummelState: State = $FighterStateMachine/Extras/Pummel

var fighterIcon: FighterIcon

var airJumpCount: int = 0
var blockHealth: float = 0.0
var diMulitplier: float = 1.0
var grabLocation: GrabBox
var hitStop: int = 0
var hitStun: int = 0
var inHitStop: bool = false
var isFastFalling: bool = false
var percent: int = 0 : set = _update_percent
var landingFrames: int = 0
var ledgeGrabCount: int = 0
var ledgeHeld: Ledge
var ledgeLock: bool
var smoothLanding: bool = false
var staleMoves: Array = ["","","","","",""]

var hitboxAngle: int = 0
var hitboxBKB: int = 0
var hitboxKBS: float = 0.0
var hitboxReversed: bool = false

func _update_percent(_percent: int):
	percent = _percent
	if percent > 999:
		percent = 999
	if fighterIcon != null:
		fighterIcon._set_percent(percent)

func _add_stale_move(move: String = ""):
	var tempStaleMoves = staleMoves.duplicate()
	tempStaleMoves.pop_back()
	staleMoves.clear()
	staleMoves.append(move)
	for staleMove in tempStaleMoves: staleMoves.append(staleMove)

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

func _return_air_attack_state() -> State:
	match inputComponent._get_move_stick():
		# Down
		0:
			return airAttackDownState
		# Left
		1:
			facingRight = false
			_set_face()
			return airAttackSideState
		# Right
		2:
			facingRight = true
			_set_face()
			return airAttackSideState
		# Up
		3:
			return airAttackUpState
		_:
			return airAttackNeutralState

func _return_air_state_stick():
	match inputComponent._get_attack_stick():
		# Down
		0:
			return airAttackDownState
		# Left
		1:
			facingRight = false
			_set_face()
			return airAttackSideState
		# Right
		2:
			facingRight = true
			_set_face()
			return airAttackSideState
		# Up
		3:
			return airAttackUpState
		_:
			return null

func _return_attack_state() -> State:
	match inputComponent._get_move_stick():
		# Down
		0:
			return attackDownState
		# Left
		1:
			facingRight = false
			_set_face()
			return attackSideState
		# Right
		2:
			facingRight = true
			_set_face()
			return attackSideState
		# Up
		3:
			return attackUpState
		_:
			return attackNeutralState

func _return_attack_state_stick():
	match inputComponent._get_attack_stick():
		# Down
		0:
			return heavyDownState
		# Left
		1:
			facingRight = false
			_set_face()
			return heavySideState
		# Right
		2:
			facingRight = true
			_set_face()
			return heavySideState
		# Up
		3:
			return heavyUpState
		_:
			return null

func _return_heavy_state() -> State:
	match inputComponent._get_move_stick():
		# Down
		0:
			return heavyDownState
		# Left
		1:
			facingRight = false
			_set_face()
			return heavySideState
		# Right
		2:
			facingRight = true
			_set_face()
			return heavySideState
		# Up
		3:
			return heavyUpState
		_:
			return heavySideState

func _return_special_state() -> State:
	match inputComponent._get_move_stick():
		# Down
		0:
			return specialDownState
		# Left
		1:
			facingRight = false
			_set_face()
			return specialSideState
		# Right
		2:
			facingRight = true
			_set_face()
			return specialSideState
		# Up
		3:
			return specialUpState
		_:
			return specialNeutralState

func _set_dead():
	stateMachine.change_state(deadState)

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

func _set_invisibility(_bool: bool) -> void:
	for hurtbox: Area2D in hurtboxes.get_children():
		hurtbox.monitorable = _bool
		hurtbox.monitoring = _bool
		hurtbox.visible = _bool

func _set_respawn():
	emit_signal("respawn_fighter")

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	blockHealth = MAX_BLOCK_HEALTH
	isFastFalling = false
	inHitStop = false
	ledgeHeld = null
	ledgeLock = false
	smoothLanding = false
	inputComponent.controllerID = MatchGlobal.players[playerID]["Controller_Index"]
	stateMachine.init(self, model, inputComponent)
	_set_face()
	visible = true

func _is_in_hitstop() -> bool:
	if hitStop > 0:
		hitStop -= 1
		if stateMachine._get_current_state_name() == "Hit":
			animationPlayer.play("Hit")
			shaker._shake(model)
		else:
			animationPlayer.pause()
		hitboxManager._set_paused(true)
		return true
	elif inHitStop:
		animationPlayer.play()
		inHitStop = false
		hitboxManager._set_paused(false)
	model.position = Vector2(0,0)
	return false

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if _is_in_hitstop(): return
	stateMachine.process_frame(delta)
	stateLabel.text = "State: " + stateMachine._get_current_state_name()
	match inputComponent._pressed("block"):
		true:
			blockHealthTimer.stop()
		false:
			if blockHealthTimer.is_stopped():
				blockHealthTimer.start()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if _is_in_hitstop(): return
	stateMachine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	stateMachine.process_input(event)

func _set_hit_stop(hitbox: Hitbox, blocked: bool):
	var _parent = hitbox.parent
	var _hitstop = hitbox.hitStop
	if blocked: _hitstop = int(_hitstop / 2.0)
	hitStop = _hitstop
	inHitStop = true
	_parent.hitStop = _hitstop
	_parent.inHitStop = true

func _damage_calculation(parent: Fighter, hitbox: Hitbox) -> int:
	var staleCount = parent.staleMoves.count(hitbox.attackName)
	if staleCount <= StaleValue.FRESH: return hitbox.damage
	var newDamage: float = 0
	match staleCount:
		StaleValue.LEVEL_THREE:
			newDamage = hitbox.damage * 0.96
		StaleValue.LEVEL_TWO:
			newDamage = hitbox.damage * 0.89
		StaleValue.LEVEL_ONE:
			newDamage = hitbox.damage * 0.82
		_:
			newDamage = hitbox.damage * 0.75
	if newDamage < 1: newDamage = 1.0
	return int(newDamage)

func _set_up_hit_state(hitbox: Hitbox):
	hitboxAngle = hitbox.angle
	hitboxBKB = hitbox.baseKnockback
	hitboxKBS = hitbox.knockbackScale
	percent += _damage_calculation(hitbox.parent, hitbox)
	hitboxReversed = hitbox.reversed
	hitStun = hitbox.hitStun
	diMulitplier = hitbox.diMultiplier
	stateMachine.change_state(hitState)

func _is_valid_pummel(_fighter: Fighter):
	return _fighter != self and _fighter.stateMachine._get_current_state_name() == "Pummel"

func _on_hurtbox_area_entered(area: Area2D) -> void:
	ledgeLock = false
	if area.collision_layer & (1 << 6):
		emit_signal("dead_fighter",playerID)
		return
	if area.collision_layer & (1 << 8):
		var grabbox: GrabBox = area
		if grabbox.parent != self:
			grabLocation = grabbox
			stateMachine.change_state(grabStunState)
			grabbox.parent.stateMachine.change_state(grabbox.parent.pummelState)
			grabLocation.grabbedFighter = self
		return
	var hitbox: Hitbox = area
	if _is_valid_pummel(hitbox.parent):
		percent += hitbox.damage
		return
	else:
		if grabLocation != null:
			grabLocation.grabbedFighter = null
			grabLocation = null
	match inputComponent._pressed("block"):
		true:
			blockHealth -= hitbox.blockDamage
			_set_hit_stop(hitbox, true)
		false:
			if hitbox.parent != self:
				hitbox.parent.smoothLanding = true
				_set_hit_stop(hitbox, false)
				_set_up_hit_state(hitbox)
				hitboxManager._delete_hitboxes()

func _on_ledge_grab_box_area_entered(ledge: Ledge) -> void:
	if ledgeGrabCount < GameModifiers.ledgeGrabLimit:
		ledgeGrabCount += 1
		ledgeHeld = ledge
		ledgeLock = true
		facingRight = !ledgeHeld.facingRight
		_set_face()
		ledgeHeld._set_ledge_grab(self)
		_set_ledge_position()
		stateMachine.change_state(ledgeState)

func _off_ledge():
	ledgeGrabCount = 0
	ledgeHeld = null
	hitboxAngle = 90
	hitboxBKB = 125
	hitboxKBS = 0.0
	hitStun = 30
	percent += 10
	stateMachine.change_state(hitState)

func _set_ledge_position():
	var newPosition = ledgeHeld.global_position - ledgePosition.position
	global_position = newPosition

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	offScreenMarker.visible = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	offScreenMarker.visible = true

func _on_block_health_timer_timeout() -> void:
	if blockHealth < MAX_BLOCK_HEALTH:
		blockHealth += 0.1
	else:
		blockHealth = MAX_BLOCK_HEALTH
