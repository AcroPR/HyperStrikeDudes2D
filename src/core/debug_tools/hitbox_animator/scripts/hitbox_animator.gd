class_name HitboxAnimator
extends Control

@onready var fighterSpawn: Node2D = $FighterSpawn
@onready var frameLabel: Label = $CanvasLayer/Frames/FrameLabel
@onready var frameSlider: HSlider = $CanvasLayer/Frames/FrameSlider
@onready var playButton: Button = $CanvasLayer/PlayAndHitboxSelect/PlayButton
@onready var selectedFighter: OptionButton = $CanvasLayer/SelectedFighter
@onready var selectedAnimation: OptionButton = $CanvasLayer/SelectedAnimation

var animationList: Array = []
var animationName: String
var fighterDir = "res://src/fighters/"
var fighterNames: Array = []
var fighterNode: Fighter
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

func _on_frame_slider_value_changed(frame: float) -> void:
	frameLabel.text = "Frame: " + str(int(frame)+1)
	var frames_to_seconds = frame/60
	fighterNode.animationPlayer.seek(frames_to_seconds)

func _on_play_button_pressed() -> void:
	match paused:
		true:
			fighterNode.animationPlayer.play(animationName, -1, 1, false)
			playButton.text = "Playing"
		false:
			fighterNode.animationPlayer.play(animationName, -1, 0, false)
			playButton.text = "Paused"
	paused = !paused

func _on_selected_animation_item_selected(index: int) -> void:
	animationName = animationList[index]
	paused = false
	frameSlider.max_value = int(fighterNode.animationPlayer.current_animation_length * 60) -1
	frameSlider.value = 1
	frameSlider.value -= 1
	_on_play_button_pressed()

func _on_selected_fighter_item_selected(index: int) -> void:
	for child in fighterSpawn.get_children():
		child.queue_free()
	var fighterPath = fighterDir + fighterNames[index] + "/fighter.tscn"
	var fighter = load(fighterPath)
	var fighterInstance: Fighter = fighter.instantiate()
	fighterSpawn.add_child(fighterInstance)
	fighterNode = fighterInstance
	fighterInstance.set_process(false)
	fighterInstance.set_physics_process(false)
	fighterInstance.offScreenMarker.set_process(false)
	fighterInstance.offScreenMarker.visible = false
	_add_selected_animations()
