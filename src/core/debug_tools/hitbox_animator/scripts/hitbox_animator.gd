class_name HitboxAnimator
extends Control

@onready var fighterSpawn: Node2D = $FighterSpawn
@onready var frameLabel: Label = $Frames/FrameLabel
@onready var frameSlider: HSlider = $Frames/FrameSlider
@onready var hitboxes: OptionButton = $PlayAndHitboxSelect/Hitboxes
@onready var pageOne: VBoxContainer = $HitboxProperties/PageOne
@onready var pageTwo: VBoxContainer = $HitboxProperties/PageTwo
@onready var pageThree: VBoxContainer = $HitboxProperties/PageThree
@onready var playButton: Button = $PlayAndHitboxSelect/PlayButton
@onready var selectedFighter: OptionButton = $SelectedFighter
@onready var selectedAnimation: OptionButton = $SelectedAnimation

var animationList: Array = []
var animationName: String
var fighterDir = "res://src/fighters/"
var fighterNames: Array = []
var fighterNode: Fighter
var hitboxStartFrames = []
var hitboxCount = 0
var paused: bool

func _add_selected_animations():
	var itemNum = 0
	animationList = fighterNode.animationPlayer.get_animation_list()
	selectedAnimation.clear()
	for animation in animationList:
		selectedAnimation.add_item(animation, itemNum)
		itemNum += 1
	_on_selected_animation_item_selected(0)

func _add_selected_fighters():
	var allFighters = DirAccess.open(fighterDir)
	var itemNum = 0
	allFighters.list_dir_begin()
	var fighterName = allFighters.get_next()
	while fighterName != "":
		selectedFighter.add_item(fighterName, itemNum)
		fighterNames.append(fighterName)
		itemNum += 1
		fighterName = allFighters.get_next()
	allFighters.list_dir_end()

func _check_hitbox_frames(currentFrame):
	for hbox in fighterNode.hitboxManager.get_child_count():
		var currentHBox: Hitbox = fighterNode.hitboxManager.get_child(hbox)
		var maxFrames = hitboxStartFrames[hbox] + currentHBox.framesActive - 1
		currentHBox.visible = (hitboxStartFrames[hbox]<=currentFrame) and (currentFrame <= maxFrames)

func _ready() -> void:
	_add_selected_fighters()
	_on_selected_fighter_item_selected(0)

func _process(_delta):
	match paused:
		false:
			if frameSlider.value == int(fighterNode.animationPlayer.current_animation_length * 60)-1:
				fighterNode.animationPlayer.seek(0)
				fighterNode.animationPlayer.play(animationName, -1, 1, false)
			frameSlider.value = fighterNode.animationPlayer.current_animation_position * 60

func _on_create_hitbox_pressed() -> void:
	hitboxes.add_item("Hitbox " + str(hitboxCount), hitboxCount)
	fighterNode.hitboxManager.add_child(Hitbox.new(50,50,0,0,true))
	
	hitboxStartFrames.append(int(frameSlider.value))
	
	for child in fighterNode.hitboxManager.get_children():
		if !child.name.contains("Hitbox"):
			child.name = "Hitbox " + str(hitboxCount)
	
	if hitboxCount == 0:
		_on_hitboxes_item_selected(0)
	
	hitboxCount += 1

func _on_delete_hitbox_pressed() -> void:
	if hitboxes.selected >= 0:
		fighterNode.hitboxManager.remove_child(fighterNode.hitboxManager.get_node(hitboxes.get_item_text(hitboxes.selected)))
		hitboxes.remove_item(hitboxes.selected)

func _on_frame_slider_value_changed(frame: float) -> void:
	frameLabel.text = "Frame: " + str(int(frame)+1)
	var frames_to_seconds = frame/60
	fighterNode.animationPlayer.seek(frames_to_seconds)
	_check_hitbox_frames(frame)

func _on_hitboxes_item_selected(_index: int) -> void:
	if hitboxes.selected >= 0:
		var hitboxNode: Hitbox = fighterNode.hitboxManager.get_node(hitboxes.get_item_text(hitboxes.selected))
		pageOne._set_values(hitboxNode)
		pageTwo._set_values(hitboxNode,_index)
		pageThree._set_values(hitboxNode)

func _on_play_button_pressed() -> void:
	match paused:
		true:
			fighterNode.animationPlayer.play(animationName, -1, 1, false)
			playButton.text = "Playing"
		false:
			fighterNode.animationPlayer.play(animationName, -1, 0, false)
			playButton.text = "Paused"
	paused = !paused

func _reset_hitboxmanager():
	hitboxCount = 0
	hitboxes.clear()
	fighterNode.hitboxManager._delete_hitboxes()

func _on_selected_animation_item_selected(index: int) -> void:
	animationName = animationList[index]
	paused = false
	frameSlider.max_value = int(fighterNode.animationPlayer.current_animation_length * 60) -1
	frameSlider.value = 1
	frameSlider.value -= 1
	_reset_hitboxmanager()
	_on_play_button_pressed()

func _on_selected_fighter_item_selected(index: int) -> void:
	for child in fighterSpawn.get_children():
		child.queue_free()
	var fighterPath = fighterDir + fighterNames[index] + "/fighter.tscn"
	var fighter = load(fighterPath)
	var fighterInstance: Fighter = fighter.instantiate()
	fighterSpawn.add_child(fighterInstance)
	fighterNode = fighterInstance
	fighterNode.set_process(false)
	fighterNode.set_physics_process(false)
	fighterNode.offScreenMarker.set_process(false)
	fighterNode.offScreenMarker.visible = false
	fighterNode.hitboxManager._set_paused(true)
	_add_selected_animations()
