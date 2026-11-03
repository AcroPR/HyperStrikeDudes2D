extends State

const DEPLETION: int = 24

@export_category("States")
@export var airState: State
@export var grabState: State
@export var idleState: State
@export var jumpSquatState: State
@export var rollState: State
@export var stunState: State

func enter() -> void:
	super()
	parent.animationPlayer.play("Block")
	frames = 0
	parent.blockBubble.visible = true

func process_frame(_delta: float) -> State:
	frames += 1
	if frames % DEPLETION == 0:
		parent.blockHealth -= 1.5
	if parent.blockHealth <= 0.0:
		parent.blockHealth = 0.0
		parent.blockBubble.visible = false
		return stunState
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(parent.groundFriction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	if inputComponent._just_pressed("move_left") or inputComponent._just_pressed("move_right"):
		parent.blockBubble.visible = false
		return rollState
	
	parent.move_and_slide()
	
	if inputComponent._just_pressed("jump"):
		parent.blockBubble.visible = false
		return jumpSquatState
	
	if !inputComponent._pressed("block"):
		parent.blockBubble.visible = false
		return idleState
	
	if inputComponent._get_strength("move_down") >= parent.RUN_THRESHOLD:
		parent.set_collision_mask_value(3,false)
	
	if !parent.is_on_floor():
		parent.blockBubble.visible = false
		return airState
	
	return null
