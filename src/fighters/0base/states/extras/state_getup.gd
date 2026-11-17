extends State

@export_category("States")
@export var idleState: State
@export var airState: State

var animationName: String

func enter() -> void:
	super()
	match parent.isJabReset:
		true:
			animationName = "GetupReset"
		false:
			animationName = "Getup"
	parent.animationPlayer.play(animationName)

func process_frame(_delta: float) -> State:
	if !parent.is_on_floor(): return airState
	if !parent.animationPlayer.is_playing():
		return idleState
	return null
