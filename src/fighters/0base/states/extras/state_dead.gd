extends State

const DEAD_FRAMES: int = 180

func enter() -> void:
	super()
	parent.visible = false
	frames = 0
	parent.velocity = Vector2.ZERO

func process_frame(_delta: float) -> State:
	if MatchGlobal.playerLives[parent.playerID] < 1: return
	frames += 1
	if frames >= DEAD_FRAMES:
		parent._set_respawn()
	return null
