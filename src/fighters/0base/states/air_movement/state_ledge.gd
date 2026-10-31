extends State

const HOLD_LEDGE_FRAMES: int = 10

@export_category("States")
@export var airState: State

var check_jump: bool

func enter() -> void:
	super()
	parent.animationPlayer.play("Ledge")
	frames = 0
	check_jump = false

func process_frame(_delta: float) -> State:
	if frames < HOLD_LEDGE_FRAMES:
		frames += 1
	if !inputComponent._pressed("jump"):
		inputComponent._hard_release("jump")
		check_jump = true
	return null

func process_physics(_delta: float) -> State:
	match frames >= HOLD_LEDGE_FRAMES:
		true:
			if inputComponent._just_pressed("jump") and check_jump:
				check_jump = false
				parent.airJumpCount = 1
				parent.velocity.y = -parent._get_velocity(parent.airJumpHeight)
				parent.ledgeHeld._set_ledge_grab(null)
				parent.ledgeHeld = null
				return airState
			
			if inputComponent._just_pressed("move_down"):
				parent.airJumpCount = 0
				parent.ledgeHeld._set_ledge_grab(null)
				parent.ledgeHeld = null
				return airState
			
			if parent._can_move():
				parent.airJumpCount = 1
				parent.velocity.y = -parent._get_velocity(parent.airJumpHeight)
				parent.ledgeHeld._set_ledge_grab(null)
				parent.ledgeHeld = null
				return airState
	
	parent.velocity.x = 0
	parent.velocity.y = 0
	
	parent.move_and_slide()
	
	return null
