extends State

const ROLL_MAX_FRAMES: int = 30

@export_category("States")
@export var airState: State
@export var idleState: State

var moveDir
var friction: int

func _roll_start_up():
	match parent.facingRight:
		true:
			parent.velocity.x = -parent.rollSpeed
		false:
			parent.velocity.x = parent.rollSpeed
	friction = parent.rollSpeed / ROLL_MAX_FRAMES

func enter() -> void:
	super()
	frames = 0
	moveDir = [!inputComponent._pressed("move_left"),!inputComponent._pressed("move_right")]
	parent._set_face_with_move_dir(moveDir)
	_roll_start_up()
	parent.animationPlayer.play("Roll")
	parent._set_invisibility(false)

func _process(_delta: float) -> void:
	frames += 1
	parent._set_invisibility(frames > 20)

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, friction)
	
	parent.move_and_slide()
	
	if parent.velocity.x == 0:
		parent._set_invisibility(true)
		return idleState
	
	if inputComponent._get_strength("move_down") >= parent.RUN_THRESHOLD:
		parent.set_collision_mask_value(3,false)
	
	if !parent.is_on_floor():
		parent._set_invisibility(true)
		return airState
	
	return null
