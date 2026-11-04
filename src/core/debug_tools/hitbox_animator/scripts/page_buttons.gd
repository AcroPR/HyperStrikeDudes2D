@tool
extends HBoxContainer

@onready var pageOne: VBoxContainer = $"../PageOne"
@onready var pageTwo: VBoxContainer = $"../PageTwo"
@onready var pageThree: VBoxContainer = $"../PageThree"
@onready var pageFour: VBoxContainer = $"../PageFour"
@onready var pageFive: VBoxContainer = $"../PageFive"

func _ready() -> void:
	_on_page_one_pressed()

func _on_page_one_pressed() -> void:
	pageOne.visible = true
	pageTwo.visible = false
	pageThree.visible = false
	pageFour.visible = false
	pageFive.visible = false

func _on_page_two_pressed() -> void:
	pageOne.visible = false
	pageTwo.visible = true
	pageThree.visible = false
	pageFour.visible = false
	pageFive.visible = false

func _on_page_three_pressed() -> void:
	pageOne.visible = false
	pageTwo.visible = false
	pageThree.visible = true
	pageFour.visible = false
	pageFive.visible = false

func _on_page_four_pressed() -> void:
	pageOne.visible = false
	pageTwo.visible = false
	pageThree.visible = false
	pageFour.visible = true
	pageFive.visible = false

func _on_page_five_pressed() -> void:
	pageOne.visible = false
	pageTwo.visible = false
	pageThree.visible = false
	pageFour.visible = false
	pageFive.visible = true
