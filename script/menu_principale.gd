class_name Main_Menu
extends Control

@onready var Start_Button= $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var Exit_Button= $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var Option_Button= $MarginContainer/HBoxContainer/VBoxContainer/Option_Button as Button
@onready var Level_button = $MarginContainer/HBoxContainer/VBoxContainer/Levels as Button
@onready var Credits_button = $MarginContainer/HBoxContainer/VBoxContainer/Credits as Button
@onready var margin_cointainer= $MarginContainer as MarginContainer
@export var start_level = preload("res://scene/main.tscn")
@onready var Options_Menu= $Options_Menu as OptionMenu
@onready  var Levels_menu = $Levels_menu as LevelsMenu


func _ready():
	handle_connecting_signals()
	
func on_button_down() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_exit_pressed() -> void:
	get_tree().quit()
	
func on_options_pressed() -> void:
	margin_cointainer.visible= false
	Options_Menu.visible=true

func on_levels_pressed() -> void:
	margin_cointainer.visible = false
	Levels_menu.visible = true
	
func on_exit_option_menu() -> void:
	margin_cointainer.visible= true
	Options_Menu.visible=false
	
func handle_connecting_signals()-> void:
	Start_Button.button_down.connect(on_button_down)
	Option_Button.button_down.connect(on_options_pressed)
	Exit_Button.button_down.connect(on_exit_pressed)
	Options_Menu.exit_option_menu.connect(on_exit_option_menu)
	Level_button.button_down.connect(on_levels_pressed)
	
	
	
