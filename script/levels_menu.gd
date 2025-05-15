class_name LevelsMenu
extends Control

@onready var level1_button = $level1_button as Button
@onready var level2_button = $level2_button as Button
@onready var level3_button = $level3_button as Button
@onready var back_button = $Back_button as Button
@export var start_level = preload("res://scene/main.tscn")


signal start_game
signal back_to_main_menu

func on_button_down() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func _on_level_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func _on_back_button_pressed() -> void:
	# Torna al menu principale
	var menu_scene = load("res://scene/menu_principale.tscn")
	get_tree().change_scene_to_packed(menu_scene)
