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
			parent._set_invisibility(150)
		false:
			animationName = "Getup"
			parent._set_invisibility(50)
	parent.animationPlayer.play(animationName)

func process_frame(_delta: float) -> State:
	if !parent.is_on_floor(): return airState
	if !parent.animationPlayer.is_playing():
		return idleState
	return null
