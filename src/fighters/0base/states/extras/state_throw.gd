extends State

@export_category("States")
@export var airState: State
@export var idleState: State

@export_category("Throw Properties")
@export var animationName: String = "ThrowF"
@export var flipFighter: bool = false

# Array of attack hitboxes
var attackHitboxes

var previousFrame: int = -1

func enter() -> void:
	super()
	parent.animationPlayer.play(animationName)
	attackHitboxes = HitboxImporter._load_csv(parent.fighterFolderName, animationName)

func _create_hitbox(current_hitbox):
	var new_hitbox = Hitbox.new()._build_from_array(current_hitbox,false,0)
	new_hitbox.reversed = parent.model.scale.x < 0
	new_hitbox.parent = parent
	new_hitbox.attackName = animationName
	parent.hitboxManager.add_child(new_hitbox)

func _check_for_hitboxes():
	var currentFrame = int(parent.animationPlayer.current_animation_position * 60)
	
	if currentFrame == previousFrame:
		return
	
	previousFrame = currentFrame
	
	for currentHitbox in attackHitboxes:
		if currentFrame == currentHitbox[0]:
			_create_hitbox(currentHitbox)

func process_frame(_delta: float) -> State:
	_check_for_hitboxes()
	if !parent.animationPlayer.is_playing():
		if flipFighter:
			parent.facingRight = !parent.facingRight
			parent._set_face()
		return idleState
	return null
